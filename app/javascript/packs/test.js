import Vue from 'vue/dist/vue.esm'
import axios from 'axios'
import VueCarousel from 'vue-carousel';
Vue.use(VueCarousel);

const app = new Vue({

    el: '#app',
    data: {
        movieInfo: {},
        pushedTags: [],
        movieList: [],
        tagList: [],
        allTagList: [],
        allTagTagsList: [],
        allMovieList: [],
        isShow: false,
        isShow2: {},
    },
    mounted() {
        axios.get("movie/tag/0")
            .then(res => {
                // this.movieList = res.data[0]['movies'];
                this.allMovieList = res.request.response;
                this.movieList = res.data.filter(function (item, index) {
                    if (item.tag == "all") return true;
                })
                this.movieList = this.movieList[0].movies
                console.log('========= mounted 2 : movie/tag/0 GET ===================');
                console.log(res.request.response);
                console.log('===========================================');
            });
        axios.get("movie/tag_tag/0")
            .then(res => {
                this.allTagTagsList = res.data;
                console.log('========= mounted 3 : movie/tag_tag/0 GET ===================');
                console.log(res.data);
                console.log('===========================================');
            });
        axios.get("movie/movie_tag/0")
            .then(res => {
                this.tagList = res.data;
                this.allTagList = res.data;
                for(let tag of res.data) {
                    this.isShow2[tag] = false;
                }
                console.log('========= mounted 1 : movie/movie_tag/0 GET ===================');
                console.log(res.data);
                console.log(this.isShow2);
                console.log('===========================================');
              });
    },
    methods: {
        setMovieInfo(id) {
            axios.get('movie/${id}')
                .then(res => {
                    this.movieInfo = res.data;
                    this.isShow = true;
                    console.log('========= setMovieInfo ===================');
                    console.log('movie id : ' + id);
                    console.log('isShow : ' + this.isShow);
                    console.log(res.data);
                    console.log('===========================================');
                });
        },
        setMovieInfo2(id, tag) {
            axios.get('movie/${id}')
                .then(res => {
                    this.movieInfo = res.data;
                    this.isShow2[tag] = true;
                    console.log('========= setMovieInfo2 ===================');
                    console.log('isShow2 : ' + tag + ' : ' + this.isShow2[tag]);
                    console.log('movie id : ' + id);
                    console.log(res.data);
                    console.log('===========================================');
                });

        },
        setPushedTag(tag) {
            this.pushedTags.push(tag);
        },
        setUnpushedTag(tag) {
            for (let i = 0; i < this.pushedTags.length; i++) {
                if (this.pushedTags[i] == tag) {
                    this.pushedTags.splice(i, 1);
                }
            }
        },
        sortAllTagList(tag) {
            var topTags = this.allTagTagsList.filter(function (item, index) {
                if (item.tag == tag) return true;
            })[0].tags

        },
        resetTag() {
            this.pushedTags = [];
        },
    },
    watch: {
        pushedTags: function (val) {
            axios.get('movie/tag/${val}')
                .then(res => {
                    console.log(res.data);
                    this.movieList = res.data[0].movies;
                });
            if (val == '') {
                this.tagList = this.allTagList;
                this.movieList = this.allMovieList[0].movies;
            }
        },
        movieList: function (val) {
            // var movie_ids = [];
            var movie_ids = [];
            for (let v of val) {
                movie_ids.push(v.id);
            }
            axios.get('movie/movie_tag/${movie_ids}')
                .then(res => {
                    console.log(res.data);
                    this.tagList = res.data;
                });
        },
        tagList: function (val) {
            for (let i = 0; i < this.tagList.length; i++) {
                if (this.pushedTags.indexOf(this.tagList[i]) >= 0) {
                    this.tagList.splice(i, 1);
                }
            }
        },
    },
    computed: {
        tagsMovieList: function () {
            return function (tag) {
                return this.allMovieList.filter(function (item, index) {
                    if (item.tag == tag) return true;
                })[0].movies
            }
        },

        tagTagsList: function () {
            return function (tag) {
                return this.allTagTagsList.filter(function (item, index) {
                    if (item.tag == tag) return true;
                })[0].tags
            }
        },
    },
 })

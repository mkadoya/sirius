import Vue from 'vue/dist/vue.esm'
import axios from 'axios'

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
    },
    mounted() {
        axios.get(`movie/movie_tag/0`)
            .then(res => {
                console.log(res.data);
                this.tagList = res.data;
                this.allTagList = res.data;
            });
        axios.get(`movie/tag/0`)
            .then(res => {
                console.log(res.data);
                // this.movieList = res.data[0]['movies'];
                this.allMovieList = res.data;
                this.movieList = res.data.filter(function (item, index) {
                    if (item.tag == "all") return true;
                })
                this.movieList = this.movieList[0].movies
            });
        axios.get(`movie/tag_tag/0`)
            .then(res => {
                console.log(res.data);
                this.allTagTagsList = res.data;
            });
    },
    methods: {
        setMovieInfo(id) {
            axios.get(`movie/${id}`)
                .then(res => {
                    console.log(res.data);
                    this.movieInfo = res.data;
                });
            this.isShow = true;
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
        changeAllTagList(tag, ctag) {
            var index = 0;
            for (let i = 0; i < this.allTagList.length; i++) {
                if (this.allTagList[i] == tag) {
                    index = i;
                }
            }
            this.allTagList.splice(index, 0, tag + "+" + ctag);
            if (this.allTagList[index + 1].indexOf('+') != -1) {
                this.allTagList.splice(index + 1, 1);
            }
            var tags = tag.split("+");
            tags.push(ctag);
            var isfirst = true;
            var movies = [];
            for (let t of tags) {
                if (movies.length == 0) {
                    movies = this.allMovieList.filter(function (item, index) {
                        if (item.tag == t) return true;
                    })[0].movies;
                    alert(movies);
                } else {
                    // movies.concat(this.allMovieList.filter(function (item, index) {
                    //     if (item.tag == t) return true;
                    // })[0].movies);
                    var temp = this.allMovieList.filter(function (item, index) {
                        if (item.tag == t) return true;
                    })[0].movies;
                    alert(movies);
                }

            }
        },
        resetTag() {
            this.pushedTags = [];
        },
    },
    watch: {
        pushedTags: function (val) {
            axios.get(`movie/tag/${val}`)
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
            axios.get(`movie/movie_tag/${movie_ids}`)
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
                var tagArray = tag.split("+");
                if (tagArray.length == 1) {
                    return this.allMovieList.filter(function (item, index) {
                        if (item.tag == tag) return true;
                    })[0].movies
                } else {
                    // alert(tag);
                    return "SF";
                    // return this.allMovieList.filter(function (item, index) {
                    //     if (item.tag == tag) return true;
                    // })[0].movies
                }

            }
        },

        tagTagsList: function () {
            return function (tag) {
                var tagArray = tag.split("+");
                if (tagArray.length == 1) {
                    return this.allTagTagsList.filter(function (item, index) {
                        if (item.tag == tag) return true;
                    })[0].tags
                } else {
                    return tagArray;
                }
            }
        },
    },

 })

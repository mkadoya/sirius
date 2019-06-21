import Vue from 'vue/dist/vue.esm'
import axios from 'axios'

const app = new Vue({

    el: '#app',
    data: {
        movieInfo: {},
        checkedTags: [],
        pushedTags: [],
        movieList: [],
        tagList: [],
        isActive: true,
    },
    mounted() {
        axios.get(`movie/movie_tag/0`)
            .then(res => {
                console.log(res.data);
                this.tagList = res.data;
            });
    },
    methods: {
        setMovieInfo(id) {
            axios.get(`movie/${id}`)
                .then(res => {
                    console.log(res.data);
                    this.movieInfo = res.data;
                });
        },
        setPushedTag(name) {
            var flag = true;
            for (let i = 0; i < this.pushedTags.length; i++) {
                if (this.pushedTags[i] == name) {
                    flag = false;
                    this.pushedTags.splice(i, 1);
                }
            }
            if (flag) {
                this.pushedTags.push(name);
            }
        },
    },
    watch: {
        checkedTags: function (val) {
            axios.get(`movie/tag/${val}`)
                .then(res => {
                    console.log(res.data);
                    this.movieList = res.data;
                });
            if (val == '') {
                axios.get(`movie/movie_tag/0`)
                    .then(res => {
                        console.log(res.data);
                        this.tagList = res.data;
                    });
            }
        },
        pushedTags: function (val) {
            axios.get(`movie/tag/${val}`)
                .then(res => {
                    console.log(res.data);
                    this.movieList = res.data;
                });
            if (val == '') {
                axios.get(`movie/movie_tag/0`)
                    .then(res => {
                        console.log(res.data);
                        this.tagList = res.data;
                    });
            }
        },
        movieList: function (val) {
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
    },

 })

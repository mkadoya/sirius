import Vue from 'vue/dist/vue.esm'
import axios from 'axios'

const app = new Vue({

    el: '#app',
    data: {
        movieInfo: {},
        checkedTags: [],
        movieList: [],
        tagList: [],
    },
    methods: {
        setMovieInfo(id) {
            axios.get(`movie/${id}`)
                .then(res => {
                    console.log(res.data);
                    this.movieInfo = res.data;
                });
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
    }
 })

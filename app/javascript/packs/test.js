import Vue from 'vue/dist/vue.esm'
import axios from 'axios'

const app = new Vue({

    el: '#app',
    data: {
        movieInfo: {},
    },
    methods: {
        setMovieInfo(id) {
            axios.get(`movie/${id}`)
                .then(res => {
                    console.log(res.data);
                    this.movieInfo = res.data;
                });
        }
    }
})

import Vue from 'vue/dist/vue.esm'

const app = new Vue({
    el: '#app',
    data: {
        message: 'hello world'
    },
    methods: {
        changeMsg: function () {
            this.message = 'change message testing'
        }
    }
})

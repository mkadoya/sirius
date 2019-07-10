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
        allMovieTagList: [],
        allMovieList: [],
        pushedTagList:[],
        isShow: false,
        isShow2: {},
    },
    mounted() {
        axios.get("movie/tag/0")
            .then(res => {
<<<<<<< HEAD
=======
                console.log(res.data);
                this.tagList = res.data;
                this.allTagList = res.data;
            });
        axios.get(`movie/movie_tag/all`)
            .then(res => {
                console.log(res.data);
                this.allMovieTagList = res.data;
            });
        axios.get(`movie/tag/0`)
            .then(res => {
                console.log(res.data);
>>>>>>> cda98fedeadd54c3660e577cac9a5fb0492cf749
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
<<<<<<< HEAD
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
=======

>>>>>>> cda98fedeadd54c3660e577cac9a5fb0492cf749
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

            var isfirst = true;
            var hash = {};

            for (let i = 0; i < this.pushedTagList.length; i++) {
                // console.log(this.pushedTagList[i].tag == tag);
                console.log("list : " + this.pushedTagList[i].tag);
                console.log("tag : " + tag);

                if (this.pushedTagList[i].tag == tag) {
                    var pushedlist = this.pushedTagList[i].pushed;
                    var p = [];
                    for (let i = 0; i < pushedlist.length; i++){
                        p.push(pushedlist[i]);
                    }
                    p.push(ctag);
                    console.log("pushedlist:  " + p);
                    hash = { tag: (tag + "+" + ctag), pushed: p }
                    this.pushedTagList.push(hash);
                    isfirst = false;
                    break;
                }
            }
            if (isfirst) {
                hash = { tag: (tag + "+" + ctag), pushed: [ctag] };
                var ispush = true;
                for (let i = 0; i < this.pushedTagList.length; i++) {
                    if (this.pushedTagList[i].tag == hash.tag) {
                        ispush = false;
                    }
                }
                if (ispush) {
                    this.pushedTagList.push(hash);
                }

                console.log("isfirst tag: " + hash.tag + " pushed: " + hash.pushed);
            } else {

                console.log("Not firsttag: " + hash.tag + " pushed: " + hash.pushed);
            }
            for (let i = 0; i < this.pushedTagList.length; i++){
                console.log( i + " : " + this.pushedTagList[i].tag);
                console.log( i + " : " + this.pushedTagList[i].pushed);
            }
        },
        unpushedTag(tag, ptag) {
            var nextTags = tag.split("+");
            nextTags.forEach((item, index) => {
                if (item === ptag) {
                    nextTags.splice(index, 1);
                }
            });
            var nextTag = "";
            nextTags.forEach((item, index) => {
                if (index == 0) {
                    nextTag = item;
                } else {
                    nextTag = nextTag + "+" + item;
                }
            });
            console.log("NEXT : "  + nextTag);
            this.allTagList.forEach((item, index) => {
                // console.log(item);
                if (item == tag) {
                    console.log("Choosed : " + tag);
                    this.allTagList.splice(index, 1);
                    this.allTagList.splice(index, 0, nextTag);
                    // this.allTagList[index] = nextTag;
                    console.log("Result : " + this.allTagList[index]);
                }
            });
            this.allTagList = this.allTagList.filter(function (x, i, self) {
                return self.indexOf(x) === i;
            });

            this.allTagList.forEach((item, index) => {
                console.log("allTagList[" + index + "] : " + item);
            });
            var changePushedTag = true;

            if (nextTags.length == 1) {
                changePushedTag = false;
            }
            this.pushedTagList.forEach((item, index) => {
                console.log("pushed Tag List :" + item.tag)
                if (item.tag == nextTag) {
                    changePushedTag = false;
                }
            });
            if (changePushedTag) {
                var pushedtags = [];
                this.pushedTagList.forEach((item, index) => {
                    if (item.tag == tag) {
                        pushedtags = item.pushed;
                    }
                });
                var hash = { tag: nextTag, pushed: pushedtags }
                this.pushedTagList.push(hash);
            }
            console.log("change Pushed Tag : " + changePushedTag);
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
                var tagArray = tag.split("+");
                if (tagArray.length == 1) {
                    return this.allMovieList.filter(function (item, index) {
                        if (item.tag == tag) return true;
                    })[0].movies
                } else {
                    // alert(tag);
                    var movies = [];
                    for (let t of tagArray) {
                        var temps = [];
                        if (movies.length == 0) {
                            movies = this.allMovieList.filter(function (item, index) {
                                if (item.tag == t) return true;
                            })[0].movies;

                        } else {
                            var tempArray = this.allMovieList.filter(function (item, index) {
                                if (item.tag == t) return true;
                            })[0].movies;
                            for (let temp of tempArray) {
                                for (let movie of movies) {
                                    if (movie.id == temp.id) {
                                        temps.push(temp);
                                    }
                                }
                            }
                            movies = temps;
                        }
                    }
                    return movies;
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
                    var movies = [];
                    var tags = [];
                    for (let t of tagArray) {
                        var temps = [];
                        if (movies.length == 0) {
                            movies = this.allMovieList.filter(function (item, index) {
                                if (item.tag == t) return true;
                            })[0].movies;
                        } else {
                            var tempArray = this.allMovieList.filter(function (item, index) {
                                if (item.tag == t) return true;
                            })[0].movies;
                            for (let temp of tempArray) {
                                for (let movie of movies) {
                                    if (movie.id == temp.id) {
                                        temps.push(temp);
                                    }
                                }
                            }
                            movies = temps;
                        }
                    }
                    for (let movie of movies) {
                        // alert(tags.length);
                        if (tags.length == 0) {
                            tags = this.allMovieTagList.filter(function (item, index) {
                                if (item.movie_id == movie.id) return true;
                            })[0].tags;
                        } else {
                            var tempArray = this.allMovieTagList.filter(function (item, index) {
                                if (item.movie_id == movie.id) return true;
                            })[0].tags;
                            for (let i = 0; i < tempArray.length; i++) {
                                if (tags.indexOf(tempArray[i]) == -1) {
                                    tags.push(tempArray[i]);
                                }
                            }
                        }
                    }
                    for (let i = 0; i < tagArray.length; i++) {
                        tags = tags.filter(function (t) {
                            return t != tagArray[i];
                        });
                    }
                    return tags;
                }
            }
        },

        pushedTagsList: function () {
            return function (tag) {
                var tags = []
                if (tag.indexOf('+') != -1) {
                    tags = this.pushedTagList.filter(function (item, index) {
                        if (item.tag == tag) return true;
                    })[0].pushed;
                } else {
                    tags = [];
                }
                return tags
            }
        },
    },
 })

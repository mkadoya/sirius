import Vue from 'vue/dist/vue.esm'
import VueSimpleSuggest from 'vue-simple-suggest'
import 'vue-simple-suggest/dist/styles.css'
import axios from 'axios'
import VueCarousel from 'vue-carousel';
Vue.use(VueCarousel);

const app = new Vue({

    el: '#newapp',
    components: {
        VueSimpleSuggest,
    },
    data: {
        isLoading: true,
        defaultTags: [],
        defaultItems: [],
        defaultTagItemList: [],
        defaultItemInfo: [],
        isShowDefaultItem: false,
        allTagItemList: [],
        allItemList: [],
        allItemInfoList: [],
        itemInfo:[],
        newId: 0,
        tag_keyword: "",
    },
    mounted() {
        axios.get(`home/defaultTagItemList`)
            .then(res => {
                // console.log(res.data);
                this.defaultTagItemList = res.data;
                this.defaultTags = res.data.tags;;
                this.defaultItems = res.data.items
            });
        axios.get(`home/allTagItemList`)
            .then(res => {
                // console.log(res.data);
                this.allTagItemList = res.data;
                this.newId = this.allTagItemList.length;
                // console.log("newID : " + this.newId);
            });
        axios.get(`home/allItemList`)
            .then(res => {
                // console.log(res.data);
                this.allItemList = res.data;
            });
        axios.get(`home/allItemInfoList`)
            .then(res => {
                // console.log(res.data);
                this.allItemInfoList = res.data;
                this.isLoading = false;
            });
    },
    methods: {
        pushDefaultTag(tag) {
            this.defaultTagItemList.push.push(tag);
            var pushtags = this.defaultTagItemList.push;
            var itemsArray = [];
            var items = [];
            for (let pushindex = 0; pushindex < pushtags.length; pushindex++) {
                for (let itemindex = 0; itemindex < this.allTagItemList.length; itemindex++) {
                    if (this.allTagItemList[itemindex].tag == pushtags[pushindex]) {
                        itemsArray.push(this.allTagItemList[itemindex].items);
                    }
                }
            }
            for (let a = 0; a < itemsArray.length; a++) {
                if (a == 0) {
                    for (let i = 0; i < itemsArray[a].length; i++) {
                        items.push(itemsArray[a][i]);
                    }
                } else {
                    items = items.filter(
                        item => items.includes(item) && itemsArray[a].includes(item)
                    )
                }
            }


            var tags = [];
            for (let i = 0; i < items.length; i++) {
                if (i == 0) {
                    for (let it = 0; it < this.allItemList.length; it++){
                        if (this.allItemList[it].id == items[i]) {
                            for (let t = 0; t < this.allItemList[it].tags.length; t++){
                                tags.push(this.allItemList[it].tags[t].tag);
                            }
                        }
                    }
                } else {
                    for (let it = 0; it < this.allItemList.length; it++) {
                        if (this.allItemList[it].id == items[i]) {
                            for (let t = 0; t < this.allItemList[it].tags.length; t++) {
                                if (tags.indexOf(this.allItemList[it].tags[t].tag) == -1) {
                                    tags.push(this.allItemList[it].tags[t].tag);
                                }
                            }
                        }
                    }
                }
            }
            for (let p = 0; p < pushtags.length; p++) {
                if (tags.indexOf(pushtags[p]) >= 0) {
                    tags.splice(tags.indexOf(pushtags[p]), 1);
                }
            }
            this.defaultTagItemList.tags = tags;
            this.defaultTagItemList.items = items;
            console.log(this.defaultTagItemList.items);
        },

        unpushDefaultTag(tag) {
            this.defaultTagItemList.push = this.defaultTagItemList.push.filter(function (ptag) {
                return ptag !== tag;
            });
            var pushtags = this.defaultTagItemList.push;

            // itemsを更新
            var items = [];
            if (pushtags.length == 0) {
                for (let it = 0; it < this.allItemList.length; it++) {
                    items.push(this.allItemList[it].id);
                }
            } else {
                var itemsArray = [];
                for (let pushindex = 0; pushindex < pushtags.length; pushindex++) {
                    for (let itemindex = 0; itemindex < this.allTagItemList.length; itemindex++) {
                        if (this.allTagItemList[itemindex].tag == pushtags[pushindex] && this.allTagItemList[itemindex].tag.length == 1) {
                            itemsArray.push(this.allTagItemList[itemindex].items);
                        }
                    }
                }
                for (let a = 0; a < itemsArray.length; a++) {
                    if (a == 0) {
                        for (let i = 0; i < itemsArray[a].length; i++) {
                            items.push(itemsArray[a][i]);
                        }
                    } else {
                        items = items.filter(
                            item => items.includes(item) && itemsArray[a].includes(item)
                        )
                    }
                }
            }
            this.defaultTagItemList.items = items;

            // tagsを更新
            var tags = [];
            if (pushtags.length == 0) {
                for (let t = 0; t < this.defaultTags.length; t++) {
                    tags.push(this.defaultTags[t]);
                }
            } else {
                for (let i = 0; i < items.length; i++) {
                    if (i == 0) {
                        for (let it = 0; it < this.allItemList.length; it++) {
                            if (this.allItemList[it].id == items[i]) {
                                for (let t = 0; t < this.allItemList[it].tags.length; t++) {
                                    tags.push(this.allItemList[it].tags[t].tag);
                                }
                            }
                        }
                    } else {
                        for (let it = 0; it < this.allItemList.length; it++) {
                            if (this.allItemList[it].id == items[i]) {
                                for (let t = 0; t < this.allItemList[it].tags.length; t++) {
                                    if (tags.indexOf(this.allItemList[it].tags[t].tag) == -1) {
                                        tags.push(this.allItemList[it].tags[t].tag);
                                    }
                                }
                            }
                        }
                    }
                }
                for (let p = 0; p < pushtags.length; p++) {
                    if (tags.indexOf(pushtags[p]) >= 0) {
                        tags.splice(tags.indexOf(pushtags[p]), 1);
                    }
                }
            }
            this.defaultTagItemList.tags = tags;
        },
        resetDefaultTag() {
            this.defaultTagItemList.items = this.defaultItems;
            this.defaultTagItemList.tags = this.defaultTags;
            this.defaultTagItemList.push = [];
        },
        pushAllTagItem(id, ptag) {
            // 対象のタグをtagItemへ挿入
            var tagItem;
            var tagItemIndex = 0;
            // console.log("ID: " +  id)
            for (let ti = 0; ti < this.allTagItemList.length; ti++) {
                if (this.allTagItemList[ti].id == id) {
                    tagItem = this.allTagItemList[ti];
                    tagItemIndex = ti;
                }
            }
            // console.log(tagItem);

            // tagを更新


            // pushを更新
            var pushtags = [];
            for (let t = 0; t < tagItem.push.length; t++) {
                pushtags.push(tagItem.push[t]);
            }
            pushtags.push(ptag);
            pushtags.push(tagItem.tag);


            // itemsを更新
            var itemsArray = [];
            var items = [];

            for (let pushindex = 0; pushindex < pushtags.length; pushindex++) {
                for (let itemindex = 0; itemindex < this.allTagItemList.length; itemindex++) {
                    if (this.allTagItemList[itemindex].tag == pushtags[pushindex]) {
                        itemsArray.push(this.allTagItemList[itemindex].items);
                        // console.log("pushindex : " + pushindex)
                        // console.log(pushtags[pushindex]);
                        // console.log(itemsArray);
                        break;
                    }
                }
            }
            for (let a = 0; a < itemsArray.length; a++) {
                if (a == 0) {
                    for (let i = 0; i < itemsArray[a].length; i++) {
                        items.push(itemsArray[a][i]);
                    }
                } else {
                    items = items.filter(
                        item => items.includes(item) && itemsArray[a].includes(item)
                    )
                }
            }
            // tagItem.items = items;

            // tagsを更新
            var tags = [];
            for (let i = 0; i < items.length; i++) {
                if (i == 0) {
                    for (let it = 0; it < this.allItemList.length; it++) {
                        if (this.allItemList[it].id == items[i]) {
                            for (let t = 0; t < this.allItemList[it].tags.length; t++) {
                                tags.push(this.allItemList[it].tags[t].tag);
                            }
                        }
                    }
                } else {
                    for (let it = 0; it < this.allItemList.length; it++) {
                        if (this.allItemList[it].id == items[i]) {
                            for (let t = 0; t < this.allItemList[it].tags.length; t++) {
                                if (tags.indexOf(this.allItemList[it].tags[t].tag) == -1) {
                                    tags.push(this.allItemList[it].tags[t].tag);
                                }
                            }
                        }
                    }
                }
            }
            for (let p = 0; p < pushtags.length; p++) {
                if (tags.indexOf(pushtags[p]) >= 0) {
                    tags.splice(tags.indexOf(pushtags[p]), 1);
                }
            }
            // tagItem.tags = tags;

            // pushを再更新
            pushtags.pop();
            tagItem.push = pushtags;

            // 関連するタグをソートする
            var sorttags = [];
            for (let t = (tags.length - 1); 0 <= t; t--) {
                sorttags.push(tags[t]);
            }
            for (let p = 0; p < tagItem.tag.length; p++) {
                for (let s = 0; s < sorttags.length; s++){
                    if (sorttags[s] == tagItem.tag[p]) {
                        sorttags.splice(s, 1);
                        break;
                    }
                }
                sorttags.push(tagItem.tag[p]);
            }
            for (let p = 0; p < pushtags.length; p++) {
                sorttags.push(pushtags[p]);
            }

            // console.log(sorttags);
            // console.log("length : " + this.allTagItemList.length);
            for (let t = 0; t < sorttags.length; t++) {
                for (let ti = 0; ti < this.allTagItemList.length; ti++) {
                    if (this.allTagItemList[ti].tag == sorttags[t] && tagItemIndex < ti) {
                        this.allTagItemList.splice(tagItemIndex + 1, 0, this.allTagItemList[ti]);
                        // console.log(" oku : " + this.allTagItemList[tagItemIndex + 1].tag);
                        this.allTagItemList.splice(ti + 1, 1);
                        break;
                    } else if (this.allTagItemList[ti].tag == sorttags[t] && tagItemIndex > ti) {
                        // console.log(" temae : " + this.allTagItemList[ti].tag);
                        var temp_tag = [];
                        var temp_items = [];
                        var temp_tags = [];

                        for (let i = 0; i < this.allTagItemList[ti].tag.length; i++) {
                            temp_tag.push(this.allTagItemList[ti].tag[i]);
                        }
                        for (let i = 0; i < this.allTagItemList[ti].items.length; i++){
                            temp_items.push(this.allTagItemList[ti].items[i]);
                        }
                        for (let i = 0; i < this.allTagItemList[ti].tags.length; i++) {
                            temp_tags.push(this.allTagItemList[ti].tags[i]);
                        }
                        var hash = { id: this.newId, tag: temp_tag, items: temp_items, tags: temp_tags, push: [], show: false };
                        this.allTagItemList.splice(tagItemIndex + 1, 0, hash);

                        for (let ti2 = tagItemIndex + 2; ti2 < this.allTagItemList.length; ti2++){
                            var delete_flag = true;
                            for (let i = 0; i < this.allTagItemList[ti2].tag.length; i++) {
                                if (this.allTagItemList[ti2].tag[i] !== temp_tag[i]) {
                                    delete_flag = false;
                                }
                            }
                            if (delete_flag ) {
                                // console.log("delete this tag id : " + this.allTagItemList[ti2].id + " : " + this.allTagItemList[ti2].tag);
                                // console.log("delete this temp tag : " + temp_tag);
                                this.allTagItemList.splice(ti2, 1);
                            }
                        }
                        // console.log(hash);
                        // console.log(this.allTagItemList[ti]);
                        this.newId += 1;
                        break;
                    } else if (this.allTagItemList[ti].tag == sorttags[t] && tagItemIndex == ti) {
                        // console.log(" onaji : " + this.allTagItemList[ti].tag);
                        var temp_tag = [];
                        var temp_items = [];
                        var temp_tags = [];
                        for (let i = 0; i < this.allTagItemList[ti].tag.length; i++) {
                            temp_tag.push(this.allTagItemList[ti].tag[i]);
                        }
                        for (let i = 0; i < this.allTagItemList[ti].items.length; i++) {
                            temp_items.push(this.allTagItemList[ti].items[i]);
                        }
                        for (let i = 0; i < this.allTagItemList[ti].tags.length; i++) {
                            temp_tags.push(this.allTagItemList[ti].tags[i]);
                        }
                        var hash = { id: this.newId, tag: temp_tag, items: temp_items, tags: temp_tags, push: [], show: false };
                        this.allTagItemList.splice(tagItemIndex + 1, 0, hash);
                        // console.log(hash);
                        this.newId += 1;
                        break;
                    }
                }
            }

            // Debug
            // for (let ti = 0; ti < this.allTagItemList.length; ti++) {
            //     console.log(this.allTagItemList[ti].id + " : " + this.allTagItemList[ti].tag);
            // }

            // pushされたtagItemを変更する
            tagItem.tag.push(ptag);
            tagItem.items = items;
            for (let t = 0; t < tags.length; t++) {
                for (let ti = 0; ti < tagItem.tag.length; ti++) {
                    if (tags[t] == tagItem.tag[ti]) {
                        tags.splice(t, 1);
                        break;
                    }
                }
            }
            tagItem.tags = tags;
        },
        unpushAllTagItem(id, ptag) {
            // 対象のタグをtagItemへ挿入
            var tagItem;
            var tagItemIndex = 0;
            // console.log("ID: " +  id)
            for (let ti = 0; ti < this.allTagItemList.length; ti++) {
                if (this.allTagItemList[ti].id == id) {
                    tagItem = this.allTagItemList[ti];
                    tagItemIndex = ti;
                }
            }
            // console.log("target : " + tagItem.id + " : " + tagItem.tag);
            // console.log("unpushed tag : " + tag);


            // pushを更新
            var pushtags = [];
            for (let t = 0; t < tagItem.push.length; t++) {
                pushtags.push(tagItem.push[t]);
            }
            pushtags = pushtags.filter(p => p !== ptag);

            // tagを更新
            var tag = [];
            for (let t = 0; t < tagItem.tag.length; t++) {
                tag.push(tagItem.tag[t]);
            }
            tag = tag.filter(p => p !== ptag);

            // itemsを更新
            var items = [];
            if (tag.length == 0) {
                for (let it = 0; it < this.allItemList.length; it++) {
                    items.push(this.allItemList[it].id);
                }
            } else {
                var itemsArray = [];
                for (let pushindex = 0; pushindex < tag.length; pushindex++) {
                    for (let itemindex = 0; itemindex < this.allTagItemList.length; itemindex++) {
                        if (this.allTagItemList[itemindex].tag == tag[pushindex] && this.allTagItemList[itemindex].tag.length == 1) {
                            itemsArray.push(this.allTagItemList[itemindex].items);
                        }
                    }
                }
                for (let a = 0; a < itemsArray.length; a++) {
                    if (a == 0) {
                        for (let i = 0; i < itemsArray[a].length; i++) {
                            items.push(itemsArray[a][i]);
                        }
                    } else {
                        items = items.filter(
                            item => items.includes(item) && itemsArray[a].includes(item)
                        )
                    }
                }
            }

            // tagsを更新
            var tags = [];
            for (let i = 0; i < items.length; i++) {
                if (i == 0) {
                    for (let it = 0; it < this.allItemList.length; it++) {
                        if (this.allItemList[it].id == items[i]) {
                            for (let t = 0; t < this.allItemList[it].tags.length; t++) {
                                // tags.push(this.allItemList[it].tags[t]);
                                tags.push(this.allItemList[it].tags[t].tag);
                            }
                        }
                    }
                } else {
                    for (let it = 0; it < this.allItemList.length; it++) {
                        if (this.allItemList[it].id == items[i]) {
                            for (let t = 0; t < this.allItemList[it].tags.length; t++) {
                                if (tags.indexOf(this.allItemList[it].tags[t].tag) == -1) {
                                    // tags.push(this.allItemList[it].tags[t]);
                                    tags.push(this.allItemList[it].tags[t].tag);
                                }
                            }
                        }
                    }
                }
            }
            for (let p = 0; p < tag.length; p++) {
                if (tags.indexOf(tag[p]) >= 0) {
                    tags.splice(tags.indexOf(tag[p]), 1);
                }
            }

            // targetのtagと被る他のtagを削除する。
            for (let ti = tagItemIndex + 1; ti < this.allTagItemList.length; ti++) {
                var delete_flag = true;
                for (let i = 0; i < tag.length; i++) {
                    if (tag[i] !== this.allTagItemList[ti].tag[i]) {
                        delete_flag = false;
                    }
                }
                if (delete_flag && tagItem.id != this.allTagItemList[ti].id) {
                    // console.log("target : " + tagItem.id + " : " + tagItem.tag);
                    // console.log("delete : " + this.allTagItemList[ti].id + " : " + this.allTagItemList[ti].tag);
                    this.allTagItemList.splice(ti, 1);
                }
            }

            //更新
            tagItem.tag = tag;
            tagItem.items = items;
            tagItem.tags = tags;
            tagItem.push = pushtags;
        },
        showDefaultItem(item_id) {
            this.isShowDefaultItem = true;
            this.isShowDefaultItemDetails = true;
            for (let i = 0; i < this.allItemInfoList.length; i++) {
                if (this.allItemInfoList[i].id == item_id) {
                    this.defaultItemInfo = this.allItemInfoList[i];
                }
            }
        },
        showItem(id, item_id) {
            // console.log("id : " + id);
            for (let i = 0; i < this.allTagItemList.length; i++) {
                if (this.allTagItemList[i].id == id) {
                    // console.log(this.allTagItemList[i]);
                    this.allTagItemList[i].show = true;
                }
                // console.log("each tag : " + this.allTagItemList[i].id + " : " + this.allTagItemList[i].show + " : " + this.allTagItemList[i].tag)
            }
            for (let i = 0; i < this.allItemInfoList.length; i++){
                if (this.allItemInfoList[i].id == item_id) {
                    this.itemInfo = this.allItemInfoList[i];
                }
            }
        },
        pushThumbs(item_tag) {
            item_tag.push = !item_tag.push;
            if (item_tag.push) {
                item_tag.value += 1;
            } else {
                item_tag.value -= 1;
            }
        },
        defaultSearchAllTagItemList(tag){
            for (let ti = 0; ti < this.allTagItemList.length; ti++) {
                if (this.allTagItemList[ti].tag == tag) {
                    this.allTagItemList.splice(0, 0, this.allTagItemList[ti]);
                    this.allTagItemList.splice(ti + 1, 1);
                }
            }
        },
        pushShowDefaultItem() {
            this.isShowDefaultItem = !this.isShowDefaultItem;
        },
        pushShowItem(tagItem) {
            tagItem.show = !tagItem.show;
        },
        searchAllTagItem(id, tag) {
            var tagItemIndex = 0;
            for (let ti = 0; ti < this.allTagItemList.length; ti++) {
                if (this.allTagItemList[ti].id == id) {
                    tagItemIndex = ti;
                }
            }
            // console.log("index : " + tagItemIndex);
            // console.log("tag : " + tag);
            for (let ti = 0; ti < this.allTagItemList.length; ti++) {
                if (this.allTagItemList[ti].tag == tag && tagItemIndex < ti) {
                    this.allTagItemList.splice(tagItemIndex + 1, 0, this.allTagItemList[ti]);
                    console.log(" oku : " + this.allTagItemList[tagItemIndex + 1].tag);
                    this.allTagItemList.splice(ti + 1, 1);
                    break;
                } else if (this.allTagItemList[ti].tag == tag && tagItemIndex > ti) {
                    console.log(" temae : " + this.allTagItemList[ti].tag);
                    var temp_tag = [];
                    var temp_items = [];
                    var temp_tags = [];

                    for (let i = 0; i < this.allTagItemList[ti].tag.length; i++) {
                        temp_tag.push(this.allTagItemList[ti].tag[i]);
                    }
                    for (let i = 0; i < this.allTagItemList[ti].items.length; i++) {
                        temp_items.push(this.allTagItemList[ti].items[i]);
                    }
                    for (let i = 0; i < this.allTagItemList[ti].tags.length; i++) {
                        temp_tags.push(this.allTagItemList[ti].tags[i]);
                    }
                    var hash = { id: this.newId, tag: temp_tag, items: temp_items, tags: temp_tags, push: [], show: false };
                    this.allTagItemList.splice(tagItemIndex + 1, 0, hash);

                    for (let ti2 = tagItemIndex + 2; ti2 < this.allTagItemList.length; ti2++) {
                        var delete_flag = true;
                        for (let i = 0; i < this.allTagItemList[ti2].tag.length; i++) {
                            if (this.allTagItemList[ti2].tag[i] !== temp_tag[i]) {
                                delete_flag = false;
                            }
                        }
                        if (delete_flag) {
                            // console.log("delete this tag id : " + this.allTagItemList[ti2].id + " : " + this.allTagItemList[ti2].tag);
                            // console.log("delete this temp tag : " + temp_tag);
                            this.allTagItemList.splice(ti2, 1);
                        }
                    }
                    // console.log(hash);
                    // console.log(this.allTagItemList[ti]);
                    this.newId += 1;
                    break;
                } else if (this.allTagItemList[ti].tag == tag && tagItemIndex == ti) {
                    // console.log(" onaji : " + this.allTagItemList[ti].tag);
                    var temp_tag = [];
                    var temp_items = [];
                    var temp_tags = [];
                    for (let i = 0; i < this.allTagItemList[ti].tag.length; i++) {
                        temp_tag.push(this.allTagItemList[ti].tag[i]);
                    }
                    for (let i = 0; i < this.allTagItemList[ti].items.length; i++) {
                        temp_items.push(this.allTagItemList[ti].items[i]);
                    }
                    for (let i = 0; i < this.allTagItemList[ti].tags.length; i++) {
                        temp_tags.push(this.allTagItemList[ti].tags[i]);
                    }
                    var hash = { id: this.newId, tag: temp_tag, items: temp_items, tags: temp_tags, push: [], show: false };
                    this.allTagItemList.splice(tagItemIndex + 1, 0, hash);
                    // console.log(hash);
                    this.newId += 1;
                    break;
                }
            }
        }
    },
    watch: {
        tag_keyword: function (val) {
            var reset_flag = true;
            for (let t = 0; t < this.defaultTagItemList.tags.length; t++){
                if (val == this.defaultTagItemList.tags[t]) {
                    this.pushDefaultTag(val);
                    reset_flag = false;
                }
            }
            if (reset_flag) {
                for (let p = 0; p < this.defaultTagItemList.push.length; p++) {
                    this.resetDefaultTag();
                }
            }
        },
    },
    computed: {
        getImage: function () {
            return function (item) {
                var image = "";
                for (let it = 0; it < this.allItemList.length; it++) {
                    if (this.allItemList[it].id == item) {
                        image = this.allItemList[it].image;
                    }
                }
                return image;
            }
        },
        getTag: function () {
            return function (tags) {
                var tag = "";
                for (let t = 0; t < tags.length; t++) {
                    if ( t == 0) {
                        tag = tags[t];
                    } else {
                        tag = tag + ", " + tags[t];
                    }
                }
                return tag;
            }
        },
        getItemTags: function () {
            return function (item_id) {
                var tags = [];
                for (let it = 0; it < this.allItemList.length; it++) {
                    if (this.allItemList[it].id == item_id) {
                        for (let t = 0; t < this.allItemList[it].tags.length; t++){
                            tags.push(this.allItemList[it].tags[t]);
                        }
                    }
                }
                return tags;
            }
        },
        getDefaultItem: function () {
            return this.defaultItemInfo;
        },
        getYoutubeUrl: function () {
            return function (url) {
                return url + "?rel=0&controls=0&autoplay=0&showinfo=0&modestbranding=1&wmode=transparent";
            }
        },
        isEmptyText: function () {
            return function (text) {
                if (!text) {
                    return false;
                } else {
                    return true;
                }
            }
        },
    },

 })

<template>
    <div id="user-summary">
        <div class="row mt-3 mb-5">
            <h1 class="user-name">User transactions – {{ balanceData.displayName }}</h1>
            <span class="text-muted fs-5">{{ balanceData.userEmail }}</span>
        </div>
        <p class="text-muted my-2 balance_date">
            Last updated on {{ formattedDate }} <a href="#" @click.prevent="refreshBalance" :disabled="loading" :class="loading ? 'disabled' : ''"><i class="bi bi-arrow-clockwise"></i> <span v-text="refreshButtonText"></span></a>
        </p>
        <div class="row row-flex gx-2 mt-1 mb-3">
            <div class="col-md-4 col-sm-12 mb-2">
                <div class="card">
                    <div class="card-body">
                        <h6 class="card-title">Balance:</h6>
                        <div class="card-text text-center">
                            <h2>{{ formatNumber(balanceData.balance) }}</h2>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4 col-sm-12 mb-2">
                <div class="card">
                    <div class="card-body">
                        <h6 class="card-title">Available Balance:</h6>
                        <div class="card-text text-center">
                            <h2>{{ formatNumber(balanceData.availableBalance) }}</h2>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4 col-sm-12 mb-2" v-if="displayYTD">
                <div class="card">
                    <div class="card-body">
                        <h6 class="card-title" v-text="ytdLabel"></h6>
                        <div class="card-text text-center">
                            <h2>{{ formatNumber(balanceData.accountingPeriodEarnings) }}</h2>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import dayjs from "dayjs";
const advancedFormat = require("dayjs/plugin/advancedFormat");
dayjs.extend(advancedFormat);

export default {
    name: "UserSummary",
    props: {
        balanceData: {},
        config: {},
    },
    data() {
        return {
            loading: false,
        };
    },
    methods: {
        formatNumber: function (number) {
            return number.toLocaleString("en-GB");
        },
        refreshBalance: function () {
            this.loading = true;
            return this.$emit("refresh");
        },
    },
    computed: {
        formattedDate: function () {
            return dayjs(this.balanceData.balanceDate).format("dddd, MMMM Do, YYYY");
        },
        displayYTD: function () {
            return this.config.displaySettings?.displayYTD;
        },
        ytdLabel: function () {
            if (this.displayYTD) {
                return (this.config.displaySettings?.ytdLabel || "Current period total earnings") + ":";
            }
            return "Current period total earnings:";
        },
        refreshButtonText: function () {
            if (this.loading) {
                return "Refreshing...";
            }
            return "Refresh";
        },
    },
};
</script>

<style scoped>
.balance_date {
    font-size: 0.8rem;
}

.user-name {
    margin-bottom: 0;
}
</style>

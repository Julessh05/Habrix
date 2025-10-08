package dev.jules.habrix.models.data

data class Frequency(val days: Int) {

    // Static variables for default frequencies
    companion object {
        internal val DAILY = Frequency(1)

        internal val WEEKLY = Frequency(7)

        internal val MONTHLY = Frequency(30)

        internal val YEARLY = Frequency(365)
    }
}

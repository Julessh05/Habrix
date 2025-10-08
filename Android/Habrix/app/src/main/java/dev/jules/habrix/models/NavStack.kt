package dev.jules.habrix.models

import androidx.navigation3.runtime.NavKey

data object HomeKey : NavKey

data object AddHabitKey : NavKey

data object CalendarKey : NavKey

object NavStack {

    internal var stack: MutableList<NavKey> = mutableListOf(HomeKey)


    internal fun back() {
        stack.removeLastOrNull()
    }
}
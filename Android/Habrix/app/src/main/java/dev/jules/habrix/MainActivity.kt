package dev.jules.habrix

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.navigation3.runtime.entryProvider
import androidx.navigation3.ui.NavDisplay
import dev.jules.habrix.models.AddHabitKey
import dev.jules.habrix.models.CalendarKey
import dev.jules.habrix.models.HomeKey
import dev.jules.habrix.models.NavStack
import dev.jules.habrix.ui.theme.HabrixTheme
import dev.jules.habrix.ui.views.AddHabit
import dev.jules.habrix.ui.views.Calendar
import dev.jules.habrix.ui.views.Home

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            HabrixTheme {
                NavDisplay(
                    backStack = NavStack.stack,
                    entryProvider = entryProvider {
                        entry<HomeKey> {
                            Home(applicationContext)
                        }
                        entry<CalendarKey> {
                            Calendar(applicationContext)
                        }
                        entry<AddHabitKey> {
                            AddHabit(applicationContext)
                        }
                    },
                    onBack = { NavStack.back() }
                )
            }
        }
    }
}
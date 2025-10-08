package dev.jules.habrix.ui.views

import android.content.Context
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.input.rememberTextFieldState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.material3.Button
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextField
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import dev.jules.habrix.controller.HabitsController
import dev.jules.habrix.models.NavStack
import dev.jules.habrix.models.data.Frequency
import dev.jules.habrix.models.data.Habit
import kotlin.uuid.ExperimentalUuidApi

@OptIn(ExperimentalUuidApi::class, ExperimentalMaterial3Api::class)
@Composable
internal fun AddHabit(context: Context) {
    val nameTextFieldState = rememberTextFieldState()
    var dropdownDisplayed: Boolean = false
    var frequency: Frequency = Frequency.DAILY
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text("New Habit")
                },
                navigationIcon = {
                    IconButton(onClick = { NavStack.back() }) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, "navigate back")
                    }
                }
            )
        },
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxHeight()
                .fillMaxWidth(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            Text("") // Spaceholder for layout arrangement
            Column {
                TextField(nameTextFieldState, label = { Text("Name") })
                Box {
                    TextButton(onClick = { dropdownDisplayed = !dropdownDisplayed }) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.Center
                        ) {
                            Icon(
                                imageVector = if (dropdownDisplayed) Icons.Default.KeyboardArrowUp else Icons.Default.KeyboardArrowDown,
                                contentDescription = "Dropdown icon"
                            )
                            Text(frequency.days.toString(), modifier = Modifier.padding(8.dp))
                        }
                    }
                    DropdownMenu(
                        expanded = dropdownDisplayed,
                        onDismissRequest = { dropdownDisplayed = false }
                    ) {
                        Text("Test")
                    }
                }
            }
            Button(onClick = {
                val habit =
                    Habit(
                        id = 1,
                        name = nameTextFieldState.text as String,
                        frequency = Frequency.DAILY.days
                    )
                HabitsController.getInstance(context).storeHabit(habit)
                NavStack.back()
            }, modifier = Modifier.padding(bottom = 8.dp)) {
                Text("Done", modifier = Modifier.padding(horizontal = 64.dp))
            }
        }
    }
}
package dev.jules.habrix.ui.views

import android.content.Context
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.FloatingActionButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import dev.jules.habrix.controller.HabitsController
import dev.jules.habrix.models.AddHabitKey
import dev.jules.habrix.models.NavStack
import dev.jules.habrix.models.data.Habit
import dev.jules.habrix.storage.db.HabitsDatabase
import kotlinx.coroutines.ExperimentalCoroutinesApi

@OptIn(ExperimentalMaterial3Api::class, ExperimentalCoroutinesApi::class)
@Composable
internal fun Home(context: Context) {
    HabitsDatabase.getDatabase(context)
    val habits = HabitsController.getInstance(context).getAllHabits()
    Scaffold(
        modifier = Modifier.fillMaxSize(),
        topBar = {
            TopAppBar(
                title = { Text("Habits") }
            )
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = {
                    NavStack.navigate(AddHabitKey)
                },
                shape = FloatingActionButtonDefaults.shape
            ) {
                Icon(Icons.Default.Add, "Add habit")
            }
        }
    ) { innerPadding ->
        if (habits.isEmpty()) {
            Column(
                modifier = Modifier
                    .padding(innerPadding)
                    .fillMaxHeight()
                    .fillMaxWidth(),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                Text(
                    "Nothing to show here",
                    fontStyle = FontStyle.Normal,
                    fontSize = 20.sp,
                    modifier = Modifier.padding(vertical = 6.dp)
                )
                Text("No habits added to the app")
            }
            Button(onClick = {}) {
                Text("Add Habit")
            }
        } else {
            Column(
                modifier = Modifier
                    .padding(innerPadding)
                    .fillMaxHeight()
                    .fillMaxWidth(),
                verticalArrangement = Arrangement.Top,
                horizontalAlignment = Alignment.Start,
            ) {
                LazyColumn {
                    items(habits) { habit ->
                        HabitContainer(habit)
                    }
                }
            }
        }
    }
}

@Composable
private fun HabitContainer(habit: Habit) {
    Button(onClick = {}) {
        Text(habit.name)
    }
}
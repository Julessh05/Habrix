package dev.jules.habrix.controller

import android.content.Context
import android.util.Log
import dev.jules.habrix.models.data.Habit
import dev.jules.habrix.models.interfaces.Loggable
import dev.jules.habrix.storage.dao.HabitDao
import dev.jules.habrix.storage.db.HabitsDatabase
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.asCoroutineDispatcher
import kotlinx.coroutines.launch
import java.util.concurrent.Executors

internal class HabitsController : Loggable {

    override val TAG: String = this.javaClass.name

    companion object {
        private var instance: HabitsController? = null

        fun getInstance(context: Context): HabitsController {
            return instance ?: HabitsController(context)
        }
    }

    private val habitsDao: HabitDao

    constructor(context: Context) {
        this.habitsDao = HabitsDatabase.getDatabase(context).habitsDao()
    }

    fun getAllHabits(): List<Habit> {
        var habits: List<Habit> = emptyList()
        CoroutineScope(Executors.newFixedThreadPool(1).asCoroutineDispatcher()).launch {
            try {
                habits = habitsDao.getAllHabits()
            } catch (e: Exception) {
                Log.e(TAG, "Couldn't access habits database: ${e.message}")
            }
        }
        return habits
    }

    fun storeHabit(habit: Habit) {
        CoroutineScope(Executors.newFixedThreadPool(1).asCoroutineDispatcher()).launch {
            try {
                habitsDao.insertHabit(habit)
            } catch (e: Exception) {
                Log.e(TAG, "Couldn't access habits database: ${e.message}")
            }
        }
    }
}
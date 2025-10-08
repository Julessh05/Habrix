package dev.jules.habrix.storage.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import dev.jules.habrix.models.data.Habit
import dev.jules.habrix.models.data.HabitCompletion

@Dao
interface HabitDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insertHabit(habit: Habit)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insertHabitCompletion(habitCompletion: HabitCompletion)

    @Delete
    fun deleteHabit(habit: Habit)

    @Delete
    fun deleteHabitCompletion(habitCompletion: HabitCompletion)

    @Query("SELECT * FROM habit")
    fun getAllHabits(): List<Habit>
}
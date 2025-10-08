package dev.jules.habrix.storage.db

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import dev.jules.habrix.models.data.Habit
import dev.jules.habrix.models.data.HabitCompletion
import dev.jules.habrix.storage.dao.HabitDao

@Database(entities = [Habit::class, HabitCompletion::class], version = 1, exportSchema = false)
abstract class HabitsDatabase : RoomDatabase() {

    abstract fun habitsDao(): HabitDao

    companion object {

        @Volatile
        private var Instance: HabitsDatabase? = null

        internal fun getDatabase(context: Context): HabitsDatabase {
            return Instance ?: synchronized(this) {
                Room.databaseBuilder(context, HabitsDatabase::class.java, "habits_database")
                    .fallbackToDestructiveMigrationOnDowngrade(dropAllTables = true)
                    .build()
                    .also {
                        Instance = it
                    }

            }
        }
    }
}
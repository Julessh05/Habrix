package dev.jules.habrix.models.data

import androidx.room.Entity
import androidx.room.PrimaryKey
import kotlin.uuid.ExperimentalUuidApi

@Entity(tableName = "habit_completion")
data class HabitCompletion @OptIn(ExperimentalUuidApi::class) constructor(
    @PrimaryKey(autoGenerate = true) val id: Int,
    val habitID: Int,
    val timeStamp: String
)

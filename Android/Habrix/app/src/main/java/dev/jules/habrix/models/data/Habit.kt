package dev.jules.habrix.models.data

import androidx.room.Entity
import androidx.room.PrimaryKey
import kotlin.uuid.ExperimentalUuidApi

@Entity(tableName = "habit")
data class Habit @OptIn(ExperimentalUuidApi::class) constructor(
    @PrimaryKey(autoGenerate = true) val id: Int,
    val name: String,
    val frequency: Int,
)
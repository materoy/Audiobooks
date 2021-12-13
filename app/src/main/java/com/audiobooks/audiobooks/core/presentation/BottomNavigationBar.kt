package com.audiobooks.audiobooks.core.presentation

import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp


@Composable
fun BottomNavigationBar(
    mainScreens: List<AudiobooksScreen>,
    onTabSelected: (AudiobooksScreen) -> Unit,
    currentScreen: AudiobooksScreen
) {
    BottomAppBar(
        contentColor = MaterialTheme.colors.onBackground,
        elevation = 22.dp,
        cutoutShape = CircleShape,
        modifier = Modifier.clip(RoundedCornerShape(topStart = 15.dp, topEnd = 15.dp))
    ) {
        mainScreens.forEach { item ->
            BottomNavigationItem(
                selected = item == currentScreen,
                selectedContentColor = MaterialTheme.colors.primary,
                unselectedContentColor = Color.Gray,
                onClick = { onTabSelected(item) },
                icon = {
                    Icon(imageVector = item.icon!!, contentDescription = item.name,
                    modifier = Modifier.size(30.dp))
                },
            )
        }
    }
}



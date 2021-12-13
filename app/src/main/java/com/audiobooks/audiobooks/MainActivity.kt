package com.audiobooks.audiobooks

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.audiobooks.audiobooks.core.presentation.AudiobooksScreen
import com.audiobooks.audiobooks.core.presentation.BottomNavigationBar
import com.audiobooks.audiobooks.explore.presentation.ExploreScreen
import com.audiobooks.audiobooks.ui.theme.AudiobooksTheme
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            AudiobooksTheme {
                // A surface container using the 'background' color from the theme
                Surface(color = MaterialTheme.colors.background) {
                    AudiobooksApp()
                }
            }
        }
    }
}

@Composable
fun AudiobooksApp() {
    val navController = rememberNavController()
    val backStackEntry = navController.currentBackStackEntryAsState()
    val currentScreen = AudiobooksScreen.fromRoute(backStackEntry.value?.destination?.route)
    val mainScreens = AudiobooksScreen.values().filter { screen -> screen.icon != null }

    val scaffoldState = rememberScaffoldState()
    Scaffold(
        scaffoldState = scaffoldState,
        bottomBar = {
            if (mainScreens.contains(currentScreen)) {
                BottomNavigationBar(
                    mainScreens = mainScreens,
                    onTabSelected = { screen ->
                        navController.navigate(screen.name)
                    }, currentScreen = currentScreen
                )
            }
        },
        drawerShape = MaterialTheme.shapes.small,
        floatingActionButtonPosition = FabPosition.Center,
        isFloatingActionButtonDocked = true,
        floatingActionButton = {
            FloatingActionButton(shape = CircleShape,
                backgroundColor = MaterialTheme.colors.primary,
                modifier = Modifier.border(
                    BorderStroke(2.dp, color = Color.White),
                    shape = CircleShape
                ),
                onClick = {
                    AudiobooksScreen.Player.name.let {
                        navController.navigate(it) {
                            popUpTo(navController.graph.findStartDestination().id) {
                                saveState = true
                            }
                            launchSingleTop = true
                            restoreState = true
                        }
                    }
                    AudiobooksScreen.Player.name.let { navController.navigate(it) }
                }) {
                Icon(imageVector = Icons.Default.PlayArrow, contentDescription = "play_button")
            }
        }
    ) {
        NavHost(
            navController = navController, startDestination = AudiobooksScreen.Home.name,
        ) {
            composable(AudiobooksScreen.Home.name) {
                ExploreScreen(scaffoldState)
            }
        }
    }
}


@Preview(showBackground = true)
@Composable
fun DefaultPreview() {
    AudiobooksTheme {
        AudiobooksApp()
    }
}
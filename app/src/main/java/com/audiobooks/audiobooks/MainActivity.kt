package com.audiobooks.audiobooks

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.padding
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.audiobooks.audiobooks.core.presentation.AudiobooksScreen
import com.audiobooks.audiobooks.core.presentation.BottomNavigationBar
import com.audiobooks.audiobooks.explore.presentation.HomeScreen
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
    Scaffold(
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
        isFloatingActionButtonDocked = true
    ) { innerPadding ->
        ApplicationNavigationHost(navController, Modifier.padding(innerPadding))
        HomeScreen()
    }
}

@Composable
fun ApplicationNavigationHost(
    navController: NavHostController,
    modifier: Modifier = Modifier
) {

    NavHost(navController = navController, startDestination = AudiobooksScreen.Home.name) {
        composable(AudiobooksScreen.Home.name) {
            HomeScreen()
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
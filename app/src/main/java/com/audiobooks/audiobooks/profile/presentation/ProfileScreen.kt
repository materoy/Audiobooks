package com.audiobooks.audiobooks.profile.presentation

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Edit
import androidx.compose.material.icons.outlined.Logout
import androidx.compose.material.icons.outlined.Settings
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.audiobooks.audiobooks.ui.theme.AudiobooksTheme
import com.skydoves.landscapist.CircularReveal
import com.skydoves.landscapist.glide.GlideImage

@Composable
fun ProfileScreen(navController: NavController?) {
    Box(modifier = Modifier.fillMaxSize()) {
        Column(modifier = Modifier) {
            Text(
                text = "Profile", style = MaterialTheme.typography.h6, modifier = Modifier
                    .padding(horizontal = 20.dp, vertical = 20.dp)
            )

            Box(
                Modifier
                    .fillMaxSize()
                    .padding(horizontal = 30.dp), contentAlignment = Alignment.Center
            ) {
                Card(
                    modifier = Modifier
                        .fillMaxHeight()
                        .padding(top = 20.dp, bottom = 60.dp)
                        .clip(RoundedCornerShape(20.dp))
                ) {
                    Column(
                        verticalArrangement = Arrangement.SpaceEvenly,
                        modifier = Modifier
                            .fillMaxWidth(),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        /// Profile image


                        Text(text = "John Doe")
                        Row {
                            BookStatistics(title = "audiobooks", count = 24)
                            BookStatistics(title = "read", count = 20)
                            BookStatistics(title = "favorites", count = 10)
                        }

                        // Settings button
                        MenuEntryButton(icon = Icons.Outlined.Settings, title = "Settings", onPressed = {
//                            navController!!.navigate(AudiobooksScreen.Settings.name)
                        })
                        MenuEntryButton(icon = Icons.Outlined.Edit, title = "Edit profile", onPressed = { })
                        MenuEntryButton(icon = Icons.Outlined.Logout, title = "Logout", onPressed = { })
                    }
                }
            }
        }
    }
}

@Composable
fun BookStatistics(title: String, count: Int) {
    Column(
        modifier = Modifier
            .padding(horizontal = 5.dp), horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(text = count.toString())
        Spacer(modifier = Modifier.height(5.dp))
        Text(text = title)
    }
}

@Composable
fun MenuEntryButton(icon: ImageVector, title: String, onPressed: () -> Unit) {
    Column(modifier = Modifier.padding(horizontal = 50.dp)) {
        Row(modifier = Modifier
            .fillMaxWidth()
            .clickable { onPressed() }, horizontalArrangement = Arrangement.SpaceBetween) {
            Icon(
                imageVector = icon,
                contentDescription = title,
                modifier = Modifier,
                tint = MaterialTheme.colors.primary
            )
            Text(text = title)
        }
        Spacer(Modifier.height(10.dp))
        Divider()
    }
}

@Preview(showBackground = true)
@Composable
fun ProfileScreenPreview() {
    AudiobooksTheme {
        ProfileScreen(navController = null)
    }
}
package com.audiobooks.audiobooks.library.presentation

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Devices
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.UiMode
import androidx.compose.ui.unit.dp
import androidx.compose.material.Icon
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.GridView
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.ListAlt
import androidx.compose.ui.Alignment
import androidx.compose.ui.graphics.Color
import com.audiobooks.audiobooks.ui.theme.AudiobooksTheme
import com.google.android.material.chip.Chip
import okhttp3.internal.wait

@Composable
fun LibraryScreen() {

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 15.dp, vertical = 10.dp)
    ) {
        Row(
            Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(
                text = "Library", style = MaterialTheme.typography.h5,
                fontWeight = FontWeight.Bold
            )
            Spacer(modifier = Modifier.width(180.dp))

            Icon(imageVector = Icons.Default.GridView, contentDescription = "grid_view")
            Icon(imageVector = Icons.Default.ListAlt, contentDescription = "list_view")
        }


        // Segmented control
        // For selecting screens audiobooks podcasts and local library
        SegmentedControl(
            items = listOf(
                SegmentedControlItem("Book"),
                SegmentedControlItem("Podcast"),
                SegmentedControlItem("Local"),
            ), selected = 2,
            modifier = Modifier.padding(vertical = 10.dp)
        ) { selectedItem ->

        }

        ChipSelection(options = listOf("All", "Favorite", "History Listening"), 0) {}
    }
}

@Composable
fun ChipSelection(options: List<String>, selectedChip: Int, onSelectChip: (Int) -> Unit) {
    Row(
        Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceEvenly
    ) {
        options.forEachIndexed { index, s ->
            Text(
                text = s,
                color = if(index == selectedChip) Color.White else Color.Gray,
                modifier = Modifier
                    .background(
                        Color.Black.copy(alpha = if (index == selectedChip) .55f else .12f),
                        RoundedCornerShape(20.dp)
                    )
                    .padding(vertical = 5.dp, horizontal = 15.dp)
            )
        }
    }
}

@Preview(showBackground = true, showSystemUi = true, device = Devices.PIXEL_4)
@Composable
fun LibraryScreenPreview() {
    AudiobooksTheme {
        LibraryScreen()
    }
}
import { Injectable } from '@angular/core';
import { Playlist, AudioTrack } from 'capacitor-plugin-playlist';
import IMAPlugin from '../../shared/plugins/ima-plugin';

@Injectable({
  providedIn: 'root',
})
export class PlaylistManager {
  init() {
    // do init stuff

    Playlist.addListener('status', (data) => {
      // TODO: use info from the event to determine if an ad should be triggered
      const shouldPlayAd = data.status.value;

      if (shouldPlayAd) {
        // pause playlist
        this.pause();

        // play ad
        IMAPlugin.playAd({ adTagUrl: 'https://your-ad-tag-url' })
          // resume playlist once complete
          .then((res) => this.play())
          .catch((err) => console.error('Failed to play ad', err));
      }
    });
  }

  play() {
    Playlist.play();
  }

  pause() {
    Playlist.pause();
  }
}

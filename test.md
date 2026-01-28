### Goal
Build a tiny mobile app that fetches a random image from our API and displays it centered as a square. A button should fetch a new image. The background should adapt to the image’s colors for an immersive effect.

### API
Use the GET /image endpoint described in Swagger:
https://november7-730026606190.europe-west1.run.app/docs#/default/get_random_image_image__get

**Example Response:**

`{"url": "https://images.unsplash.com/photo-1506744038136-46273834b3fb"}`

**Notes:**
1. CORS is enabled server-side.
2. Image URLs are from Unsplash; treat them as large, remote images (use caching/placeholder strategies).

### Requirements

1. Single screen UI
* Square image centered on screen
* Background color adapts to the image
* A button labeled “Another” below the image loads a new image.

2. Fetching
* Tapping the button triggers a new GET /image, updates the image.
* Show a loading state while fetching
* Handle errors gracefully

3. Polish
* Smooth transitions (fade image in; animate background color change).
* Respect light/dark mode.
* Basic accessibility


## Submission
1. Create a public repository at Github 
2. Record a video of app's usage and upload it to the repository or provide the link in the docs
3. Share the details of the repository with us
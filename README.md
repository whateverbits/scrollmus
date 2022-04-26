# Scrollmus
A simple vanilla JS scrollspy script.

## Getting Started
Compiled and production-ready code can be found in the `dist` directory. The `src` directory contains development code.

### 1. Include Scrollmus on your site.
There are two versions of Scrollmus: the standalone version, and one that comes preloaded with polyfills for `closest()` and `CustomEvent()`, which are only supported in newer browsers.

If you're including your own polyfills or don't want to enable this feature for older browsers, use the standalone version. Otherwise, use the version with polyfills.

**Direct Download**

You can [download the files directly from GitLab](https://gitlab.com/whateverbits/scrollmus/-/archive/main/scrollmus-main.tar.gz).

```html
<script src="path/to/scrollmus.polyfill.min.js"></script>
```

**CDN**

You can also use the [jsDelivr CDN](https://www.jsdelivr.com/package/npm/scrollmus). I recommend linking to a specific version number or version range to prevent major updates from breaking your site. Scrollmus uses semantic versioning.

```html
<!-- Always get the latest version -->
<!-- Not recommended for production sites! -->
<script src="https://www.jsdelivr.com/package/npm/scrollmus/dist/scrollmus.polyfill.min.js"></script>

<!-- Get minor updates and patch fixes within a major version -->
<script src="https://www.jsdelivr.com/package/npm/scrollmus@1/dist/scrollmus.polyfill.min.js"></script>

<!-- Get patch fixes within a minor version -->
<script src="https://www.jsdelivr.com/package/npm/scrollmus@1.0/dist/scrollmus.polyfill.min.js"></script>

<!-- Get a specific version -->
<script src="https://www.jsdelivr.com/package/npm/scrollmus@1.0.0/dist/scrollmus.polyfill.min.js"></script>
```

**NPM**

You can also use NPM (or your favorite package manager).

```bash
npm install scrollmus
```

### 2. Add the markup to your HTML.
The only thing Scrollmus needs to work is a list of anchor links. They can be ordered or unordered, inline or unstyled, or even nested.

```html
<ul id="my-awesome-nav">
	<li><a href="#eenie">Eenie</a></li>
	<li><a href="#meenie">Meenie</a></li>
	<li><a href="#miney">Miney</a></li>
	<li><a href="#mo">Mo</a></li>
</ul>
```

### 3. Initialize Scrollmus.
In the footer of your page, after the content, initialize Scrollmus by passing in a selector for the navigation links that should be detected as the user scrolls.

```html
<script>
	var spy = new Scrollmus('#my-awesome-nav a');
</script>
```

### 4. Add styling.
Scrollmus adds the `.active` class to the list item (`<li></li>`) and content for the active link, but does not include any styling.

Add styles to your CSS as desired. And that's it, you're done. Nice work!

```css
#my-awesome-nav li.active a {
	font-weight: bold;
}
```

*__Note:__ you can customize the class names with [user options](#options-and-settings).*

## Nested navigation
If you have a nested navigation menu with multiple levels, Scrollmus can also apply an `.active` class to the parent list items of the currently active link.

```html
<ul id="my-awesome-nav">
	<li><a href="#eenie">Eenie</a></li>
	<li>
		<a href="#meenie">Meenie</a>
		<ul>
			<li><a href="#hickory">Hickory</a></li>
			<li><a href="#dickory">Dickory</a></li>
			<li><a href="#doc">Doc</a></li>
		</ul>
	</li>
	<li><a href="#miney">Miney</a></li>
	<li><a href="#mo">Mo</a></li>
</ul>
```

Set `nested` to `true` when instantiating Scrollmus. You can also customize the class name.

```js
var spy = new Scrollmus('#my-awesome-nav a', {
	nested: true,
	nestedClass: 'active-parent'
});
```

## Catching reflows
If the content that's linked to by your navigation has different layouts at different viewports, Scrollmus will need to detect these changes and update some calculations behind-the-scenes.

Set `reflow` to `true` to enable this (it's off by default).

```js
var spy = new Scrollmus('#my-awesome-nav a', {
	reflow: true
});
```

## Accounting for fixed headers
If you have a fixed header on your page, you may want to offset when a piece of content is considered "active."

The `offset` user setting accepts either a number, or a function that returns a number. If you need to dynamically calculate dimensions, a function is the preferred method.

Here's an example that automatically calculates a header's height and offsets by that amount.

```js
// Get the header
var header = document.querySelector('#my-header');

// Initialize Scrollmus
var spy = new Scrollmus('#my-awesome-nav a', {
	offset: function () {
		return header.getBoundingClientRect().height;
	}
});
```

## API
Scrollmus includes smart defaults and works right out of the box. But if you want to customize things, it also has a robust API that provides multiple ways for you to adjust the default options and settings.

### Options and Settings
You can pass options into Scrollmus when instantiating.

```javascript
var spy = new Scrollmus('#my-awesome-nav a', {

	// Active classes
	navClass: 'active', // applied to the nav list item
	contentClass: 'active', // applied to the content

	// Nested navigation
	nested: false, // if true, add classes to parents of active link
	nestedClass: 'active', // applied to the parent items

	// Offset & reflow
	offset: 0, // how far from the top of the page to activate a content area
	reflow: false, // if true, listen for reflows

	// Event support
	events: true, // if true, emit custom events

	// End of page
	useLast: true // if true, the last page item will be set as 'active' when scrolled to bottom
});
```

### Custom Events
Scrollmus emits two custom events:

- `scrollmusActivate` is emitted when a link is activated.
- `scrollmusDeactivate` is emitted when a link is deactivated.

Both events are emitted on the list item and bubble up. You can listen for them with the `addEventListener()` method. The `event.detail` object includes the `link` and `content` elements, and the `settings` for the current instantiation.

```js
// Listen for activate events
document.addEventListener('scrollmusActivate', function (event) {

	// The list item
	var li = event.target;

	// The link
	var link = event.detail.link;

	// The content
	var content = event.detail.content;

}, false);
```

### Methods
Scrollmus also exposes several public methods.

#### setup()
Setups all of the calculations Scrollmus needs behind-the-scenes. If you dynamically add navigation items to the DOM after Scrollmus is instantiated, you can run this method to update the calculations.

**Example**

```javascript
var spy = new Scrollmus('#my-awesome-nav a');
spy.setup();
```

#### detect()
Activate the navigation link that's content is currently in the viewport.

**Example**

```javascript
var spy = new Scrollmus('#my-awesome-nav a');
spy.detect();
```

#### destroy()
Destroy the current instantiation of Scrollmus.

**Example**

```javascript
var spy = new Scrollmus('#my-awesome-nav a');
spy.destroy();
```

### Use Last Item
By default, when the user scrolls to the bottom of the page the last item will be marked active. To prevent this behavior, set `useLast` to false when you call Scrollmus. When `useLast` is false, the item at the top of the page will continue to be marked active.

```javascript
var spy = new Scrollmus('#my-awesome-nav a', {
	useLast: false
});
```

## Browser Compatibility
Scrollmus works in all modern browsers. Support back to IE 9 is available via polyfills.

### Polyfills
Support back to IE9 requires polyfills for `closest()` and `CustomEvent()`. Without them, support starts with Edge.

Use the included polyfills version of Scrollmus, or include your own.

## License
Scrollmus is distributed on GitLab under the MIT License.

[LICENSE](https://gitlab.com/whateverbits/scrollmus/-/blob/main/LICENSE)

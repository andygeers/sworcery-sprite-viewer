## Intro

I absolutely adore Superbrothers: Sword & Sworcery EP. Please don't hate me for this.

Obviously there's no way to access the game assets of the PC version of the game. But if somehow you figured out how to do that, wouldn't it be amazing to be able to view all of the little animations and things for the different characters?

## Usage

```
extract.rb <PATH_TO_PNG_SPRITE_FILE>
```

This will take a .png sprite file, and the corresponding .sdat file in the same folder, and generate a .CSS file in assets/css/gen/ and .JS file in assets/javascript/gen/ that can be used with the simple HTML template in index.html to show a particular animation for a particular character.

# monoalphabetic-cipher-genetic-algorithm

This is a genetic algorithm for breaking monoalphabetic cipher I completed as part of a challenge.
I have had to update it to recent Swift syntax so it would compile correctly - I apologise for any untidiness!

## How it works

It works by generating a pool of "keys" - these are simply alphabets arranged in a different order, which tell the algorithm which letter to map to which other. The encrypted text is "translated" using each of these keys, and its "bigram frequencies" are analysed - this is used to rank the keys. Some keys are kept "intact", others are "mutated", and others are removed and replaced with new random ones.

After many iterations, hopefully we are left with a key that can translate the encrypted text back into English.

## Possible modifications

I imagine this algorithm could work with different languages - you would however need to replace the bigrams file with a file that contains bigram frequencies for the appropriate language. I haven't tried this yet, but it might work! (If you do this, make sure you keep the same format as my bigrams file)

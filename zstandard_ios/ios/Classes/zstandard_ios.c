// Relative import to be able to reuse the C sources.
// See the comment in ../zstandard_ios.podspec for more information.

// Define ZSTD_STATIC_LINKING_ONLY to include all symbols (including experimental ones)

#include "zstd/lib/zstd.h"

#include "zstd/lib/ffeo.c"

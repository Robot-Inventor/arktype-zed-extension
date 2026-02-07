use zed_extension_api as zed;

struct ArkTypeExtension;

impl zed::Extension for ArkTypeExtension {}

zed::register_extension!(ArkTypeExtension);

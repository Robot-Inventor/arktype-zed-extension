use zed_extension_api as zed;

struct ArkTypeExtension;

impl zed::Extension for ArkTypeExtension {
    fn new() -> Self {
        Self
    }
}

zed::register_extension!(ArkTypeExtension);

package generator

import (
	"fmt"

	"android/soong/android"
)

func etherExpandVariables(ctx android.ModuleContext, in string) string {
	etherVars := ctx.Config().VendorConfig("etherVarsPlugin")

	out, err := android.Expand(in, func(name string) (string, error) {
		if etherVars.IsSet(name) {
			return etherVars.String(name), nil
		}
		// This variable is not for us, restore what the original
		// variable string will have looked like for an Expand
		// that comes later.
		return fmt.Sprintf("$(%s)", name), nil
	})

	if err != nil {
		ctx.PropertyErrorf("%s: %s", in, err.Error())
		return ""
	}

	return out
}

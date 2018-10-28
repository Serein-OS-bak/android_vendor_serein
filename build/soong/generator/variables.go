package generator

import (
	"fmt"

	"android/soong/android"
)

func sereinExpandVariables(ctx android.ModuleContext, in string) string {
	sereinVars := ctx.Config().VendorConfig("sereinVarsPlugin")

	out, err := android.Expand(in, func(name string) (string, error) {
		if sereinVars.IsSet(name) {
			return sereinVars.String(name), nil
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

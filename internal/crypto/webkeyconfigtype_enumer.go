// Code generated by "enumer -type WebKeyConfigType -trimprefix WebKeyConfigType -text -json -linecomment"; DO NOT EDIT.

package crypto

import (
	"encoding/json"
	"fmt"
	"strings"
)

const _WebKeyConfigTypeName = "RSAECDSAED25519"

var _WebKeyConfigTypeIndex = [...]uint8{0, 0, 3, 8, 15}

const _WebKeyConfigTypeLowerName = "rsaecdsaed25519"

func (i WebKeyConfigType) String() string {
	if i < 0 || i >= WebKeyConfigType(len(_WebKeyConfigTypeIndex)-1) {
		return fmt.Sprintf("WebKeyConfigType(%d)", i)
	}
	return _WebKeyConfigTypeName[_WebKeyConfigTypeIndex[i]:_WebKeyConfigTypeIndex[i+1]]
}

// An "invalid array index" compiler error signifies that the constant values have changed.
// Re-run the stringer command to generate them again.
func _WebKeyConfigTypeNoOp() {
	var x [1]struct{}
	_ = x[WebKeyConfigTypeUnspecified-(0)]
	_ = x[WebKeyConfigTypeRSA-(1)]
	_ = x[WebKeyConfigTypeECDSA-(2)]
	_ = x[WebKeyConfigTypeED25519-(3)]
}

var _WebKeyConfigTypeValues = []WebKeyConfigType{WebKeyConfigTypeUnspecified, WebKeyConfigTypeRSA, WebKeyConfigTypeECDSA, WebKeyConfigTypeED25519}

var _WebKeyConfigTypeNameToValueMap = map[string]WebKeyConfigType{
	_WebKeyConfigTypeName[0:0]:       WebKeyConfigTypeUnspecified,
	_WebKeyConfigTypeLowerName[0:0]:  WebKeyConfigTypeUnspecified,
	_WebKeyConfigTypeName[0:3]:       WebKeyConfigTypeRSA,
	_WebKeyConfigTypeLowerName[0:3]:  WebKeyConfigTypeRSA,
	_WebKeyConfigTypeName[3:8]:       WebKeyConfigTypeECDSA,
	_WebKeyConfigTypeLowerName[3:8]:  WebKeyConfigTypeECDSA,
	_WebKeyConfigTypeName[8:15]:      WebKeyConfigTypeED25519,
	_WebKeyConfigTypeLowerName[8:15]: WebKeyConfigTypeED25519,
}

var _WebKeyConfigTypeNames = []string{
	_WebKeyConfigTypeName[0:0],
	_WebKeyConfigTypeName[0:3],
	_WebKeyConfigTypeName[3:8],
	_WebKeyConfigTypeName[8:15],
}

// WebKeyConfigTypeString retrieves an enum value from the enum constants string name.
// Throws an error if the param is not part of the enum.
func WebKeyConfigTypeString(s string) (WebKeyConfigType, error) {
	if val, ok := _WebKeyConfigTypeNameToValueMap[s]; ok {
		return val, nil
	}

	if val, ok := _WebKeyConfigTypeNameToValueMap[strings.ToLower(s)]; ok {
		return val, nil
	}
	return 0, fmt.Errorf("%s does not belong to WebKeyConfigType values", s)
}

// WebKeyConfigTypeValues returns all values of the enum
func WebKeyConfigTypeValues() []WebKeyConfigType {
	return _WebKeyConfigTypeValues
}

// WebKeyConfigTypeStrings returns a slice of all String values of the enum
func WebKeyConfigTypeStrings() []string {
	strs := make([]string, len(_WebKeyConfigTypeNames))
	copy(strs, _WebKeyConfigTypeNames)
	return strs
}

// IsAWebKeyConfigType returns "true" if the value is listed in the enum definition. "false" otherwise
func (i WebKeyConfigType) IsAWebKeyConfigType() bool {
	for _, v := range _WebKeyConfigTypeValues {
		if i == v {
			return true
		}
	}
	return false
}

// MarshalJSON implements the json.Marshaler interface for WebKeyConfigType
func (i WebKeyConfigType) MarshalJSON() ([]byte, error) {
	return json.Marshal(i.String())
}

// UnmarshalJSON implements the json.Unmarshaler interface for WebKeyConfigType
func (i *WebKeyConfigType) UnmarshalJSON(data []byte) error {
	var s string
	if err := json.Unmarshal(data, &s); err != nil {
		return fmt.Errorf("WebKeyConfigType should be a string, got %s", data)
	}

	var err error
	*i, err = WebKeyConfigTypeString(s)
	return err
}

// MarshalText implements the encoding.TextMarshaler interface for WebKeyConfigType
func (i WebKeyConfigType) MarshalText() ([]byte, error) {
	return []byte(i.String()), nil
}

// UnmarshalText implements the encoding.TextUnmarshaler interface for WebKeyConfigType
func (i *WebKeyConfigType) UnmarshalText(text []byte) error {
	var err error
	*i, err = WebKeyConfigTypeString(string(text))
	return err
}

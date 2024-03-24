#include QMK_KEYBOARD_H

enum layers {
    LINUX_BASE,
    LINUX_FN,
    WIN_BASE,
    WIN_FN,
};

// Linux
#define KC_CTESC  MT(MOD_LCTL, KC_ESC)
#define FN_LINUX  LT(LINUX_FN, KC_SPACE)

// Windows
#define KC_TASK   LGUI(KC_TAB)
#define KC_FLXP   LGUI(KC_E)

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [LINUX_BASE] = LAYOUT_91_ansi(
        KC_MUTE,  KC_ESC,     KC_F1,        KC_F2,     KC_F3,    KC_F4,    KC_F5,     /*F6*/ KC_F6,    KC_F7,    KC_F8,    KC_F9,    KC_F10,   KC_F11,       KC_F12,   KC_INS,   KC_DEL,   KC_MUTE,
        _______,  KC_GRV,     KC_1,         KC_2,      KC_3,     KC_4,     KC_5,      /*6 */ KC_6,     KC_7,     KC_8,     KC_9,     KC_0,     KC_MINS,      KC_EQL,   KC_BSPC,            KC_PGUP,
        _______,  KC_TAB,     KC_Q,         KC_W,      KC_E,     KC_R,     KC_T,      /*Y */ KC_Y,     KC_U,     KC_I,     KC_O,     KC_P,     KC_LBRC,      KC_RBRC,  KC_BSLS,            KC_PGDN,
        _______,  KC_CTESC,   KC_A,         KC_S,      KC_D,     KC_F,     KC_G,      /*H */ KC_H,     KC_J,     KC_K,     KC_L,     KC_SCLN,  KC_QUOT,                KC_ENT,             KC_HOME,
        _______,  KC_LSFT,                  KC_Z,      KC_X,     KC_C,     KC_V,      /*B */ KC_B,     KC_N,     KC_M,     KC_COMM,  KC_DOT,   KC_SLSH,                KC_RSFT,  KC_MS_UP,
        _______,  KC_LCTL,    MO(LINUX_FN), KC_LWIN,   KC_LALT,            FN_LINUX,  /*  */                     KC_SPC,             KC_RALT,  MO(LINUX_FN), KC_RCTL,  KC_LEFT,  KC_DOWN,  KC_RGHT),

    [LINUX_FN] = LAYOUT_91_ansi(
        KC_MUTE,  KC_ESC,     KC_BRID,    KC_BRIU,   KC_MCTL,  KC_LPAD,  RGB_VAD,     /*F6*/ RGB_VAI,  KC_MPRV,  KC_MPLY,  KC_MNXT,  KC_MUTE,  KC_VOLD,      KC_VOLU,  KC_INS,   KC_DEL,   KC_MUTE,
        _______,  _______,    _______,    _______,   _______,  _______,  _______,     /*6 */ _______,  _______,  _______,  _______,  _______,  _______,      _______,  _______,            _______,
        _______,  RGB_TOG,    RGB_MOD,    RGB_VAI,   RGB_HUI,  RGB_SAI,  RGB_SPI,     /*Y */ _______,  _______,  _______,  _______,  _______,  _______,      _______,  _______,            _______,
        _______,  _______,    RGB_RMOD,   RGB_VAD,   RGB_HUD,  RGB_SAD,  RGB_SPD,     /*H */ KC_LEFT,  KC_DOWN,  KC_UP,    KC_RGHT,  _______,  _______,                _______,            _______,
        _______,  _______,                _______,   _______,  _______,  _______,     /*B */ _______,  NK_TOGG,  _______,  _______,  _______,  _______,                _______,  _______,
        _______,  _______,    _______,    _______,   _______,            _______,     /*  */                     _______,            _______,  _______,      _______,  _______,  _______,  _______),

    [WIN_BASE] = LAYOUT_91_ansi(
        KC_MUTE,  KC_ESC,     KC_F1,      KC_F2,     KC_F3,    KC_F4,    KC_F5,      /*F6*/ KC_F6,    KC_F7,    KC_F8,    KC_F9,    KC_F10,   KC_F11,       KC_F12,   KC_INS,   KC_DEL,   KC_MUTE,
        _______,  KC_GRV,     KC_1,       KC_2,      KC_3,     KC_4,     KC_5,       /*6 */ KC_6,     KC_7,     KC_8,     KC_9,     KC_0,     KC_MINS,      KC_EQL,   KC_BSPC,            KC_PGUP,
        _______,  KC_TAB,     KC_Q,       KC_W,      KC_E,     KC_R,     KC_T,       /*Y */ KC_Y,     KC_U,     KC_I,     KC_O,     KC_P,     KC_LBRC,      KC_RBRC,  KC_BSLS,            KC_PGDN,
        _______,  KC_CAPS,    KC_A,       KC_S,      KC_D,     KC_F,     KC_G,       /*H */ KC_H,     KC_J,     KC_K,     KC_L,     KC_SCLN,  KC_QUOT,                KC_ENT,             KC_HOME,
        _______,  KC_LSFT,                KC_Z,      KC_X,     KC_C,     KC_V,       /*B */ KC_B,     KC_N,     KC_M,     KC_COMM,  KC_DOT,   KC_SLSH,                KC_RSFT,  KC_UP,
        _______,  KC_LCTL,    KC_LWIN,    KC_LALT,   MO(WIN_FN),         KC_SPC,     /*  */                     KC_SPC,             KC_RALT,  MO(WIN_FN),   KC_RCTL,  KC_LEFT,  KC_DOWN,  KC_RGHT),

    [WIN_FN] = LAYOUT_91_ansi(
        RGB_TOG,  _______,    KC_BRID,    KC_BRIU,   KC_TASK,  KC_FLXP,  RGB_VAD,    /*F6*/ RGB_VAI,  KC_MPRV,  KC_MPLY,  KC_MNXT,  KC_MUTE,  KC_VOLD,      KC_VOLU,  _______,  _______,  RGB_TOG,
        _______,  _______,    _______,    _______,   _______,  _______,  _______,    /*6 */ _______,  _______,  _______,  _______,  _______,  _______,      _______,  _______,            _______,
        _______,  RGB_TOG,    RGB_MOD,    RGB_VAI,   RGB_HUI,  RGB_SAI,  RGB_SPI,    /*Y */ _______,  _______,  _______,  _______,  _______,  _______,      _______,  _______,            _______,
        _______,  _______,    RGB_RMOD,   RGB_VAD,   RGB_HUD,  RGB_SAD,  RGB_SPD,    /*H */ _______,  _______,  _______,  _______,  _______,  _______,                _______,            _______,
        _______,  _______,                _______,   _______,  _______,  _______,    /*B */ _______,  NK_TOGG,  _______,  _______,  _______,  _______,                _______,  _______,
        _______,  _______,    _______,    _______,   _______,            _______,    /*  */                     _______,            _______,  _______,      _______,  _______,  _______,  _______),
};

const uint16_t PROGMEM encoder_map[][NUM_ENCODERS][NUM_DIRECTIONS] = {
    [LINUX_BASE] = { ENCODER_CCW_CW(KC_VOLD, KC_VOLU), ENCODER_CCW_CW(KC_VOLD, KC_VOLU) },
    [LINUX_FN]   = { ENCODER_CCW_CW(RGB_VAD, RGB_VAI), ENCODER_CCW_CW(RGB_VAD, RGB_VAI) },
    [WIN_BASE] = { ENCODER_CCW_CW(KC_VOLD, KC_VOLU), ENCODER_CCW_CW(KC_VOLD, KC_VOLU) },
    [WIN_FN]   = { ENCODER_CCW_CW(RGB_VAD, RGB_VAI), ENCODER_CCW_CW(RGB_VAD, RGB_VAI) }
};

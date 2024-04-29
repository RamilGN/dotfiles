#include QMK_KEYBOARD_H

enum layers {
    LINUX_BASE,
    LINUX_MS,
    LINUX_FN,
    WIN_BASE,
    WIN_FN,
};

enum my_keycodes {
  // Begin a new line belove/above cursor
  NEWLINE = SAFE_RANGE,
};

// Tap & hold

#define KC_CTESC  MT(MOD_LCTL, KC_ESC)
#define SUSPC     LT(0, KC_NO)

#define FN_LINUX  LT(LINUX_FN, KC_SPACE)
#define FN_HOME   MT(MOD_LSFT, KC_HOME)
#define FN_END    MT(MOD_LSFT, KC_END)
#define MS_TAB    LT(LINUX_MS, KC_TAB)

// Windows
#define KC_TASK   LGUI(KC_TAB)
#define KC_FLXP   LGUI(KC_E)

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [LINUX_BASE] = LAYOUT_91_ansi(
        /*KN*/ KC_PSCR,         /*ESC  */ KC_ESC,    /*F1 */ KC_F1,        KC_F2,     KC_F3,          KC_F4,    KC_F5,      /*F6*/ KC_F6,    KC_F7,    KC_F8,    KC_F9,        /*F10*/ KC_F10,    KC_F11,        KC_F12,  /**/      KC_INS,   KC_DEL,    KC_MUTE,
        /*M1*/ DF(LINUX_BASE),  /*~    */ KC_GRV,    /*1  */ KC_1,         KC_2,      KC_3,           KC_4,     KC_5,       /*6 */ KC_6,     KC_7,     KC_8,     KC_9,         /*0*/   KC_0,      KC_MINS,       KC_EQL,  /**/      KC_BSPC,             KC_PGUP,
        /*M2*/ DF(WIN_BASE),    /*TAB  */ MS_TAB,    /*Q  */ KC_Q,         KC_W,      KC_E,           KC_R,     KC_T,       /*Y */ KC_Y,     KC_U,     KC_I,     KC_O,         /*P*/   KC_P,      KC_LBRC,       KC_RBRC, /**/      KC_BSLS,             KC_PGDN,
        /*M3*/ _______,         /*CAPS */ KC_CTESC,  /*A  */ KC_A,         KC_S,      KC_D,           KC_F,     KC_G,       /*H */ KC_H,     KC_J,     KC_K,     KC_L,         /*;*/   KC_SCLN,   KC_QUOT,                /**/      KC_ENT,              KC_HOME,
        /*M4*/ _______,         /*SHIFT*/ SC_LSPO,                         KC_Z,      KC_X,           KC_C,     KC_V,       /*B */ KC_B,     KC_N,     KC_M,     KC_COMM,      /*.*/   KC_DOT,    KC_SLSH,                /**/      SC_RSPC,  KC_MS_U,
        /*M5*/ _______,         /*CTL  */ KC_LCTL,   /*SPC*/ MO(LINUX_FN), KC_LGUI,    KC_LALT,                 FN_LINUX,                              SUSPC,                  /*ALT*/ KC_RALT,   MO(LINUX_FN),  KC_RCTL, /**/      KC_MS_L,  KC_MS_D,   KC_MS_R),

    [LINUX_MS]   = LAYOUT_91_ansi(
        /*KN*/ _______,         /*ESC  */ _______,   /*F1 */ _______,      _______,   _______,        _______,  _______,    /*F6*/ _______,  _______,      _______,  _______,  /*F10*/ _______,   _______,       _______, /**/      _______,  _______,   _______,
        /*M1*/ _______,         /*~    */ _______,   /*1  */ _______,      _______,   _______,        _______,  _______,    /*6 */ _______,  _______,      _______,  _______,  /*0*/   _______,   _______,       _______, /**/      _______,             _______,
        /*M2*/ _______,         /*TAB  */ _______,   /*Q  */ _______,      _______,   _______,        _______,  _______,    /*Y */ _______,  KC_MS_WH_UP,  _______,  _______,  /*P*/   _______,   _______,       _______, /**/      _______,             _______,
        /*M3*/ _______,         /*CAPS */ _______,   /*A  */ _______,      _______,   KC_MS_WH_DOWN,  _______,  _______,    /*H */ KC_MS_L,  KC_MS_D,      KC_MS_U,  KC_MS_R,  /*;*/   _______,   _______,                /**/      _______,             _______,
        /*M4*/ _______,         /*SHIFT*/ _______,                         _______,   _______,        _______,  _______,    /*B */ _______,  _______,      _______,  _______,  /*.*/   _______,   _______,                /*SHIFT*/ _______,  _______,
        /*M5*/ _______,         /*CTL  */ _______,   /*SPC*/ _______,      _______,   _______,                  KC_MS_BTN1, /*  */                         KC_MS_BTN2,         /*ALT*/ _______,   _______,       _______, /**/      _______,  _______,   _______),

    [LINUX_FN]   = LAYOUT_91_ansi(
        /*KN*/ KC_MUTE,         /*ESC  */ KC_ESC,    /*F1 */ KC_BRID,      KC_BRIU,   KC_MCTL,        KC_LPAD,  RGB_VAD,    /*F6*/ RGB_VAI,  KC_MPRV,      KC_MPLY,  KC_MNXT,  /*F10*/ KC_MUTE,   KC_VOLD,       KC_VOLU, /**/      KC_INS,   KC_DEL,    KC_MUTE,
        /*M1*/ _______,         /*~    */ _______,   /*1  */ _______,      _______,   _______,        _______,  _______,    /*6 */ _______,  _______,      _______,  _______,  /*0*/   _______,   _______,       _______, /**/      _______,             _______,
        /*M2*/ _______,         /*TAB  */ RGB_TOG,   /*Q  */ RGB_MOD,      RGB_VAI,   RGB_HUI,        RGB_SAI,  RGB_SPI,    /*Y */ _______,  _______,      _______,  NEWLINE,  /*P*/   _______,   _______,       _______, /**/      _______,             _______,
        /*M3*/ _______,         /*CAPS */ _______,   /*A  */ RGB_RMOD,     RGB_VAD,   RGB_HUD,        RGB_SAD,  RGB_SPD,    /*H */ KC_LEFT,  KC_DOWN,      KC_UP,    KC_RGHT,  /*;*/   _______,   _______,                /**/      _______,             _______,
        /*M4*/ _______,         /*SHIFT*/ FN_HOME,                         _______,   _______,        _______,  _______,    /*B */ _______,  NK_TOGG,      _______,  _______,  /*.*/   _______,   _______,                /*SHIFT*/ FN_END,   _______,
        /*M5*/ _______,         /*CTL  */ _______,   /*SPC*/ _______,      _______,   _______,                  _______,    /*  */                         _______,            /*ALT*/ _______,   _______,       _______, /**/      _______,  _______,   _______),

    [WIN_BASE]   = LAYOUT_91_ansi(
        /*KN*/ KC_PSCR,         /*ESC  */ KC_ESC,    /*F1 */ KC_F1,        KC_F2,     KC_F3,          KC_F4,    KC_F5,      /*F6*/ KC_F6,    KC_F7,        KC_F8,    KC_F9,    /*F10*/ KC_F10,    KC_F11,        KC_F12,  /**/      KC_INS,   KC_DEL,    KC_MUTE,
        /*M1*/ DF(LINUX_BASE),  /*~    */ KC_GRV,    /*1  */ KC_1,         KC_2,      KC_3,           KC_4,     KC_5,       /*6 */ KC_6,     KC_7,         KC_8,     KC_9,     /*0*/   KC_0,      KC_MINS,       KC_EQL,  /**/      KC_BSPC,             KC_PGUP,
        /*M2*/ DF(WIN_BASE),    /*TAB  */ KC_TAB,    /*Q  */ KC_Q,         KC_W,      KC_E,           KC_R,     KC_T,       /*Y */ KC_Y,     KC_U,         KC_I,     KC_O,     /*P*/   KC_P,      KC_LBRC,       KC_RBRC, /**/      KC_BSLS,             KC_PGDN,
        /*M3*/ _______,         /*CAPS */ KC_CAPS,   /*A  */ KC_A,         KC_S,      KC_D,           KC_F,     KC_G,       /*H */ KC_H,     KC_J,         KC_K,     KC_L,     /*;*/   KC_SCLN,   KC_QUOT,                /**/      KC_ENT,              KC_HOME,
        /*M4*/ _______,         /*SHIFT*/ KC_LSFT,                         KC_Z,      KC_X,           KC_C,     KC_V,       /*B */ KC_B,     KC_N,         KC_M,     KC_COMM,  /*.*/   KC_DOT,    KC_SLSH,                /*SHIFT*/ KC_RSFT,  KC_UP,
        /*M5*/ _______,         /*CTL  */ KC_LCTL,   /*SPC*/ MO(WIN_FN),   KC_LGUI,   KC_LALT,                  KC_SPC,     /*  */                         KC_SPC,             /*ALT*/ KC_RALT,   MO(WIN_FN),    KC_RCTL, /**/      KC_LEFT,  KC_DOWN,   KC_RGHT),

    [WIN_FN]     = LAYOUT_91_ansi(
        /*KN*/ RGB_TOG,         /*ESC  */ _______,   /*F1 */ KC_BRID,      KC_BRIU,   KC_TASK,        KC_FLXP,  RGB_VAD,    /*F6*/ RGB_VAI,  KC_MPRV,      KC_MPLY,  KC_MNXT,  /*F10*/ KC_MUTE,   KC_VOLD,       KC_VOLU, /**/      _______,  _______,   RGB_TOG,
        /*M1*/ _______,         /*~    */ _______,   /*1  */ _______,      _______,   _______,        _______,  _______,    /*6 */ _______,  _______,      _______,  _______,  /*0*/   _______,   _______,       _______, /**/      _______,             _______,
        /*M2*/ _______,         /*TAB  */ RGB_TOG,   /*Q  */ RGB_MOD,      RGB_VAI,   RGB_HUI,        RGB_SAI,  RGB_SPI,    /*Y */ _______,  _______,      _______,  _______,  /*P*/   _______,   _______,       _______, /**/      _______,             _______,
        /*M3*/ _______,         /*CAPS */ _______,   /*A  */ RGB_RMOD,     RGB_VAD,   RGB_HUD,        RGB_SAD,  RGB_SPD,    /*H */ _______,  _______,      _______,  _______,  /*;*/   _______,   _______,                /**/      _______,             _______,
        /*M4*/ _______,         /*SHIFT*/ _______,                         _______,   _______,        _______,  _______,    /*B */ _______,  NK_TOGG,      _______,  _______,  /*.*/   _______,   _______,                /*SHIFT*/ _______,  _______,
        /*M5*/ _______,         /*CTL  */ _______,   /*SPC*/ _______,      _______,   _______,                  _______,    /*  */                         _______,            /*ALT*/ _______,   _______,       _______, /**/      _______,  _______,   _______),
};

const uint16_t PROGMEM encoder_map[][NUM_ENCODERS][NUM_DIRECTIONS] = {
    [LINUX_BASE] =   { ENCODER_CCW_CW(KC_MS_WH_DOWN, KC_MS_WH_UP), ENCODER_CCW_CW(KC_VOLD, KC_VOLU) },
    [LINUX_MS]   =   { ENCODER_CCW_CW(KC_MS_WH_DOWN, KC_MS_WH_UP), ENCODER_CCW_CW(KC_VOLD, KC_VOLU) },
    [LINUX_FN]   =   { ENCODER_CCW_CW(RGB_VAD, RGB_VAI),           ENCODER_CCW_CW(RGB_HUD, RGB_HUI) },
    [WIN_BASE]   =   { ENCODER_CCW_CW(KC_VOLD, KC_VOLU),           ENCODER_CCW_CW(KC_VOLD, KC_VOLU) },
    [WIN_FN]     =   { ENCODER_CCW_CW(RGB_VAD, RGB_VAI),           ENCODER_CCW_CW(RGB_VAD, RGB_VAI) },
};

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case FN_LINUX:
            return 250;
        default:
            return TAPPING_TERM;
    }
}

bool get_hold_on_other_key_press(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case KC_CTESC:
            return true;
        case FN_LINUX:
            return true;
        case MS_TAB:
            return true;
        default:
            return false;
    }
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    static bool suspc_realse;

    switch (keycode) {
        case SUSPC:
            if (record->tap.count && record->event.pressed) {
                suspc_realse = false;
                tap_code16(KC_SPC);
                return false;
            }

            if (record->event.pressed) {
                suspc_realse = true;
                tap_code16(LGUI(KC_SPC));
                return false;
            }

            if (suspc_realse) {
                tap_code16(LGUI(KC_SPC));
                return false;
            }

            return false;
        case NEWLINE:
            if (record->event.pressed) {
                tap_code16(KC_END);
                tap_code16(LSFT(KC_ENT));
            }

            return false;
    }

    return true;
}

const int M1_LED_INDEX = 7;
const int M2_LED_INDEX = 15;
const int M3_LED_INDEX = 22;
const int M4_LED_INDEX = 29;
const int M5_LED_INDEX = 37;

bool rgb_matrix_indicators_advanced_user(uint8_t led_min, uint8_t led_max) {
    switch (get_highest_layer(layer_state|default_layer_state)) {
        case LINUX_BASE:
            rgb_matrix_set_color(M1_LED_INDEX, RGB_WHITE);
            break;
        case LINUX_MS:
            rgb_matrix_set_color(M1_LED_INDEX, RGB_CYAN);
            break;
        case LINUX_FN:
            rgb_matrix_set_color(M1_LED_INDEX, RGB_GOLD);
            break;
        case WIN_BASE:
            rgb_matrix_set_color(M2_LED_INDEX, RGB_WHITE);
            break;
        case WIN_FN:
            rgb_matrix_set_color(M2_LED_INDEX, RGB_GOLD);
            break;
    }

    return false;
}

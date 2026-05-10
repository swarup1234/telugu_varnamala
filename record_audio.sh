#!/bin/bash
# Telugu Varnamala — Interactive Audio Recorder
# Records one clip per letter, saves as MP3 to assets/audio/
# Usage: bash record_audio.sh

DEST=~/Desktop/AndroidApps/telugu_varnamala/assets/audio
SOX=/opt/homebrew/bin/sox
REC=/opt/homebrew/bin/rec

# All 52 letters: "filename|display letter|roman|word telugu|word english"
LETTERS=(
  "a_amma.mp3|అ|A|అమ్మ|Amma (Mother)"
  "aa_aavu.mp3|ఆ|Aa|ఆవు|Aavu (Cow)"
  "i_illu.mp3|ఇ|I|ఇల్లు|Illu (House)"
  "ee_eega.mp3|ఈ|Ee|ఈగ|Eega (Fly)"
  "u_udatha.mp3|ఉ|U|ఉడత|Udatha (Squirrel)"
  "oo_ooru.mp3|ఊ|Oo|ఊరు|Ooru (Village)"
  "ru_rushi.mp3|ఋ|Ru|ఋషి|Rushi (Sage)"
  "e_eddu.mp3|ఎ|E|ఎద్దు|Eddu (Bull)"
  "ae_enugu.mp3|ఏ|Ae|ఏనుగు|Enugu (Elephant)"
  "ai_aidu.mp3|ఐ|Ai|ఐదు|Aidu (Five)"
  "o_ontte.mp3|ఒ|O|ఒంట్టె|Ontte (Camel)"
  "oh_oda.mp3|ఓ|Oh|ఓడ|Oda (Ship)"
  "au_aushadham.mp3|ఔ|Au|ఔషధం|Aushadham (Medicine)"
  "am_ambaram.mp3|అం|Am|అంబరం|Ambaram (Sky)"
  "ah_ahaa.mp3|అః|Ah|అఃహా|Ahaa (Wow)"
  "lha.mp3|ళ|Lha|ళ|Lha sound"
  "ka_kamalam.mp3|క|Ka|కమలం|Kamalam (Lotus)"
  "kha_khagam.mp3|ఖ|Kha|ఖగం|Khagam (Bird)"
  "ga_gadiyaram.mp3|గ|Ga|గడియారం|Gadiyaram (Clock)"
  "gha_ghanta.mp3|ఘ|Gha|ఘంట|Ghanta (Bell)"
  "nga.mp3|ఙ|Nga|ఙ|Nga sound"
  "cha_chepa.mp3|చ|Cha|చేప|Chepa (Fish)"
  "chha_chhatram.mp3|ఛ|Chha|ఛత్రం|Chhatram (Umbrella)"
  "ja_jalleda.mp3|జ|Ja|జల్లెడ|Jalleda (Sieve)"
  "jha_jhari.mp3|ఝ|Jha|ఝరి|Jhari (Waterfall)"
  "nya.mp3|ఞ|Nya|ఞ|Nya sound"
  "ta_tamata.mp3|ట|Ta|టమాట|Tamata (Tomato)"
  "tha_theevi.mp3|ఠ|Tha|ఠీవి|Theevi (Dignity)"
  "da_dabbu.mp3|డ|Da|డబ్బు|Dabbu (Money)"
  "dha_dhanka.mp3|ఢ|Dha|ఢంకా|Dhanka (Drum)"
  "na2.mp3|ణ|Na|ణ|Na sound"
  "tha_thala.mp3|త|Tha|తల|Thala (Head)"
  "tha2_thaali.mp3|థ|Tha2|థాలి|Thaali (Plate)"
  "da2_daaram.mp3|ద|Da2|దారం|Daaram (Thread)"
  "dha2_dhanam.mp3|ధ|Dha2|ధనం|Dhanam (Wealth)"
  "na2_nadi.mp3|న|Na2|నది|Nadi (River)"
  "pa_paamu.mp3|ప|Pa|పాము|Paamu (Snake)"
  "pha_phalam.mp3|ఫ|Pha|ఫలం|Phalam (Fruit)"
  "ba_baathu.mp3|బ|Ba|బాతు|Baathu (Duck)"
  "bha_bhoomi.mp3|భ|Bha|భూమి|Bhoomi (Earth)"
  "ma_mamidi.mp3|మ|Ma|మామిడి|Mamidi (Mango)"
  "ya_yaanam.mp3|య|Ya|యానం|Yaanam (Vehicle)"
  "ra_raaju.mp3|ర|Ra|రాజు|Raaju (King)"
  "la_laddu.mp3|ల|La|లడ్డు|Laddu (Sweet)"
  "va_vanta.mp3|వ|Va|వంట|Vanta (Cooking)"
  "sha_shankham.mp3|శ|Sha|శంఖం|Shankham (Conch)"
  "sha2_shadbhuji.mp3|ష|Sha2|షడ్భుజి|Shadbhuji (Hexagon)"
  "sa_suryudu.mp3|స|Sa|సూర్యుడు|Suryudu (Sun)"
  "ha_hamsa.mp3|హ|Ha|హంస|Hamsa (Swan)"
  "lha2.mp3|ళ|Lha2|ళ|Lha2 sound"
  "ksha_kshanam.mp3|క్ష|Ksha|క్షణం|Kshanam (Moment)"
  "rra_raayi.mp3|ఱ|Rra|ఱాయి|Raayi (Stone)"
)

TOTAL=${#LETTERS[@]}
DONE=0

# Count already recorded
for entry in "${LETTERS[@]}"; do
  file=$(echo "$entry" | cut -d'|' -f1)
  [ -f "$DEST/$file" ] && ((DONE++))
done

clear
echo "╔══════════════════════════════════════════╗"
echo "║   తెలుగు వర్ణమాల — Audio Recorder       ║"
echo "║   Telugu Varnamala Audio Recorder        ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "  Total letters : $TOTAL"
echo "  Already done  : $DONE"
echo "  Remaining     : $((TOTAL - DONE))"
echo ""
echo "  Controls:"
echo "  Enter  → record 3 seconds"
echo "  r      → re-record last"
echo "  s      → skip this letter"
echo "  q      → quit"
echo ""
read -p "Press Enter to start..." _

i=0
for entry in "${LETTERS[@]}"; do
  ((i++))
  IFS='|' read -r file letter roman word_tel word_eng <<< "$entry"
  outfile="$DEST/$file"

  # Skip already recorded (only if file exists AND has content > 1KB)
  if [ -f "$outfile" ] && [ $(wc -c < "$outfile") -gt 1024 ]; then
    echo "[$i/$TOTAL] ✓ Already recorded: $file — skipping"
    continue
  fi

  while true; do
    clear
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Letter $i of $TOTAL"
    echo ""
    echo "  ┌─────────────────────────────────────┐"
    echo "  │                                     │"
    printf "  │   %s   %-6s                      │\n" "$letter" "($roman)"
    printf "  │   %s                    │\n" "$word_tel"
    printf "  │   %-35s │\n" "$word_eng"
    echo "  │                                     │"
    echo "  └─────────────────────────────────────┘"
    echo ""
    echo "  Say: \"$letter ... $word_tel\""
    echo ""
    echo "  [Enter] Record  [s] Skip  [q] Quit"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p "  > " choice

    case "$choice" in
      q|Q) echo "Stopped. Recorded $((i-1)) letters."; exit 0 ;;
      s|S) echo "  Skipped."; sleep 0.5; break ;;
      *)
        echo ""
        echo "  🔴 Recording in 1 second... speak now!"
        sleep 1
        echo "  🎤 Recording..."
        "$REC" -q -r 44100 -c 1 "$outfile" trim 0 3 2>/dev/null
        echo "  ✅ Saved: $file"
        sleep 0.5
        break
        ;;
    esac
  done
done

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   All done! Check assets/audio/          ║"
echo "╚══════════════════════════════════════════╝"

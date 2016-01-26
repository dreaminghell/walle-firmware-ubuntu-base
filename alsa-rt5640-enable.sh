#!/bin/bash

if [ "$1"x == ""x  ]; then
	AUDIO_ONOFF="1"
else
	AUDIO_ONOFF="$1"
fi


if [ "$AUDIO_ONOFF"x == "1"x  ]; then

echo "RT5640: Enable Headphone"

tinymix 'Stereo DAC MIXL DAC L1 Switch' 1
tinymix 'Stereo DAC MIXR DAC R1 Switch' 1
tinymix 'OUT MIXL DAC L1 Switch' 1
tinymix 'OUT MIXR DAC R1 Switch' 1
tinymix 'HP R Playback Switch' 1
tinymix 'HP L Playback Switch' 1
tinymix 'HPO MIX HPVOL Switch' 1
tinymix 'HP Channel Switch' 1

echo "RT5640: Enable MIC"

tinymix "RECMIXL BST1 Switch" 1
tinymix "RECMIXR BST1 Switch" 1
tinymix "RECMIXL BST2 Switch" 1
tinymix "RECMIXR BST2 Switch" 1
tinymix "Mono ADC MIXL ADC2 Switch" 0
tinymix "Mono ADC MIXR ADC2 Switch" 0
tinymix "Mono ADC MIXL ADC1 Switch" 1
tinymix "Mono ADC MIXR ADC1 Switch" 1
tinymix "DAI select" 0
tinymix "IN1 Boost" 8
tinymix "IN2 Boost" 8 

else

echo "RT5640: Disable Headphone"

tinymix 'Stereo DAC MIXL DAC L1 Switch' 0
tinymix 'Stereo DAC MIXR DAC R1 Switch' 0
tinymix 'OUT MIXL DAC L1 Switch' 0
tinymix 'OUT MIXR DAC R1 Switch' 0
tinymix 'HP R Playback Switch' 0
tinymix 'HP L Playback Switch' 0
tinymix 'HPO MIX HPVOL Switch' 0
tinymix 'HP Channel Switch' 0

echo "RT5640: Disable MIC"

tinymix "RECMIXL BST1 Switch" 0
tinymix "RECMIXR BST1 Switch" 0
tinymix "RECMIXL BST2 Switch" 0
tinymix "RECMIXR BST2 Switch" 0
tinymix "Mono ADC MIXL ADC1 Switch" 0
tinymix "Mono ADC MIXR ADC1 Switch" 0

fi

;/ FMODEX-include for fmodex 4.06.06
;/ (it should work for later version with unchanged API, too)
;/
;/ by Froggerprogger, 27.02.2007
;/ for contact see the PB-forums at http://www.purebasic.fr/english/
; UPDATED for PB v4.40b7 by Perkin - 23.11.2009
; Now uses Prototypes for all Library commands
; Just adapted Froggerprogger's include, rather than using new one
; To save even more on exe size, comment out FMOD_****** = GetFunction(....) lines
; for all commands you don't use.
; (I could have commented them all, then uncomment ones you did use, but safer for distro as is.)

;-#############################
;-############################# from fmod_dsp
;-#############################

Structure FMOD_DSP
  userdata.l     ; '[in]'[out] User created data the dsp plugin writer wants to attach to this object. 
EndStructure

Enumeration ; FMOD_DSP_TYPE
  #FMOD_DSP_TYPE_UNKNOWN            ; This unit was created via a non FMOD plugin so has an unknown purpose. 
  #FMOD_DSP_TYPE_MIXER              ; This unit does nothing but take inputs and mix them together then feed the result to the soundcard unit. 
  #FMOD_DSP_TYPE_OSCILLATOR         ; This unit generates sine/square/saw/triangle or noise tones. 
  #FMOD_DSP_TYPE_LOWPASS            ; This unit filters sound using a high quality, resonant lowpass filter algorithm but consumes more CPU time. 
  #FMOD_DSP_TYPE_ITLOWPASS          ; This unit filters sound using a resonant lowpass filter algorithm that is used in Impulse Tracker, but with limited cutoff range (0 to 8060hz). 
  #FMOD_DSP_TYPE_HIGHPASS           ; This unit filters sound using a resonant highpass filter algorithm. 
  #FMOD_DSP_TYPE_ECHO               ; This unit produces an echo on the sound and fades out at the desired rate. 
  #FMOD_DSP_TYPE_FLANGE             ; This unit produces a flange effect on the sound. 
  #FMOD_DSP_TYPE_DISTORTION         ; This unit distorts the sound. 
  #FMOD_DSP_TYPE_NORMALIZE          ; This unit normalizes or amplifies the sound to a certain level. 
  #FMOD_DSP_TYPE_PARAMEQ            ; This unit attenuates or amplifies a selected frequency range. 
  #FMOD_DSP_TYPE_PITCHSHIFT         ; This unit bends the pitch of a sound without changing the speed of playback. 
  #FMOD_DSP_TYPE_CHORUS             ; This unit produces a chorus effect on the sound. 
  #FMOD_DSP_TYPE_REVERB             ; This unit produces a reverb effect on the sound. 
  #FMOD_DSP_TYPE_VSTPLUGIN          ; This unit allows the use of Steinberg VST plugins 
  #FMOD_DSP_TYPE_WINAMPPLUGIN       ; This unit allows the use of Nullsoft Winamp plugins 
  #FMOD_DSP_TYPE_ITECHO             ; This unit produces an echo on the sound and fades out at the desired rate as is used in Impulse Tracker. 
  #FMOD_DSP_TYPE_COMPRESSOR         ; This unit implements dynamic compression (linked multichannel, wideband) 
  #FMOD_DSP_TYPE_SFXREVERB          ; This unit implements SFX reverb 
  #FMOD_DSP_TYPE_LOWPASS_SIMPLE     ; This unit filters sound using a simple lowpass with no resonance, but has flexible cutoff and is fast. 
EndEnumeration

Structure FMOD_DSP_PARAMETERDESC
  min.f                                 ; [in] Minimum value of the parameter (ie 100.0). 
  max.f                                 ; [in] Maximum value of the parameter (ie 22050.0). 
  defaultval.f                          ; [in] Default value of parameter. 
  name.s                                ; [in] Name of the parameter to be displayed (ie "Cutoff frequency"). 
  label.s                               ; [in] Short string to be put next to value to denote the unit type (ie "hz"). 
  description.s                         ; [in] Description of the parameter to be displayed as a help item / tooltip for this parameter. 
EndStructure

Enumeration ; FMOD_DSP_OSCILLATOR
  #FMOD_DSP_OSCILLATOR_TYPE    ; Waveform type.  0 = sine.  1 = square. 2 = sawup. 3 = sawdown. 4 = triangle. 5 = noise.  
  #FMOD_DSP_OSCILLATOR_RATE    ; Frequency of the sinewave in hz.  1.0 to 22000.0.  Default = 220.0. 
EndEnumeration

Enumeration ; FMOD_DSP_LOWPASS
  #FMOD_DSP_LOWPASS_CUTOFF     ; Lowpass cutoff frequency in hz.   1.0 to 22000.0.  Default = 5000.0. 
  #FMOD_DSP_LOWPASS_RESONANCE  ; Lowpass resonance Q value. 1.0 to 10.0.  Default = 1.0. 
EndEnumeration

Enumeration ; FMOD_DSP_ITLOWPASS
  #FMOD_DSP_ITLOWPASS_CUTOFF     ; Lowpass cutoff frequency in hz.  1.0 to 22000.0.  Default = 5000.0/ 
  #FMOD_DSP_ITLOWPASS_RESONANCE  ; Lowpass resonance Q value.  0.0 to 127.0.  Default = 1.0. 
EndEnumeration

Enumeration ; FMOD_DSP_HIGHPASS
  #FMOD_DSP_HIGHPASS_CUTOFF     ; Highpass cutoff frequency in hz.  10.0 to output 22000.0.  Default = 5000.0. 
  #FMOD_DSP_HIGHPASS_RESONANCE  ; Highpass resonance Q value.  1.0 to 10.0.  Default = 1.0. 
EndEnumeration

Enumeration ; FMOD_DSP_ECHO
  #FMOD_DSP_ECHO_DELAY        ; Echo delay in ms.  10  to 5000.  Default = 500. 
  #FMOD_DSP_ECHO_DECAYRATIO   ; Echo decay per delay.  0 to 1.  1.0 = No decay, 0.0 = total decay.  Default = 0.5. 
  #FMOD_DSP_ECHO_MAXCHANNELS  ; Maximum channels supported.  0 to 16.  0 = same as fmod's default output polyphony, 1 = mono, 2 = stereo etc.  See remarks for more.  Default = 0.  It is suggested to leave at 0! 
  #FMOD_DSP_ECHO_DRYMIX       ; Volume of original signal to pass to output.  0.0 to 1.0. Default = 1.0. 
  #FMOD_DSP_ECHO_WETMIX       ; Volume of echo signal to pass to output.  0.0 to 1.0. Default = 1.0. 
EndEnumeration

Enumeration ; FMOD_DSP_FLANGE
  #FMOD_DSP_FLANGE_DRYMIX      ; Volume of original signal to pass to output.  0.0 to 1.0. Default = 0.45. 
  #FMOD_DSP_FLANGE_WETMIX      ; Volume of flange signal to pass to output.  0.0 to 1.0. Default = 0.55. 
  #FMOD_DSP_FLANGE_DEPTH       ; Flange depth.  0.01 to 1.0.  Default = 1.0. 
  #FMOD_DSP_FLANGE_RATE        ; Flange speed in hz.  0.0 to 20.0.  Default = 0.1. 
EndEnumeration

Enumeration ; FMOD_DSP_DISTORTION
  #FMOD_DSP_DISTORTION_LEVEL    ; Distortion value.  0.0 to 1.0.  Default = 0.5. 
EndEnumeration

Enumeration ; FMOD_DSP_NORMALIZE
  #FMOD_DSP_NORMALIZE_FADETIME     ; Time to ramp the silence to full in ms.  0.0 to 20000.0. Default = 5000.0. 
  #FMOD_DSP_NORMALIZE_THRESHHOLD   ; Lower volume range threshold to ignore.  0.0 to 1.0.  Default = 0.1.  Raise higher to stop amplification of very quiet signals. 
  #FMOD_DSP_NORMALIZE_MAXAMP       ; Maximum amplification allowed.  1.0 to 100000.0.  Default = 20.0.  1.0 = no amplifaction, higher values allow more boost. 
EndEnumeration

Enumeration ; FMOD_DSP_PARAMEQ
  #FMOD_DSP_PARAMEQ_CENTER      ; Frequency center.  20.0 to 22000.0.  Default = 8000.0. 
  #FMOD_DSP_PARAMEQ_BANDWIDTH   ; Octave range around the center frequency to filter.  0.2 to 5.0.  Default = 1.0. 
  #FMOD_DSP_PARAMEQ_GAIN        ; Frequency Gain.  0.05 to 3.0.  Default = 1.0.  
EndEnumeration

Enumeration ; FMOD_DSP_PITCHSHIFT
  #FMOD_DSP_PITCHSHIFT_PITCH        ; Pitch value.  0.5 to 2.0.  Default = 1.0. 0.5 = one octave down, 2.0 = one octave up.  1.0 does not change the pitch. 
  #FMOD_DSP_PITCHSHIFT_FFTSIZE      ; FFT window size.  256, 512, 1024, 2048, 4096.  Default = 1024.  Increase this to reduce 'smearing'.  This effect is a warbling sound similar to when an mp3 is encoded at very low bitrates. 
  #FMOD_DSP_PITCHSHIFT_OVERLAP      ; Window overlap.  1 to 32.  Default = 4.  Increase this to reduce 'tremolo' effect.  Increasing it by a factor of 2 doubles the CPU usage. 
  #FMOD_DSP_PITCHSHIFT_MAXCHANNELS  ; Maximum channels supported.  0 to 16.  0 = same as fmod's default output polyphony, 1 = mono, 2 = stereo etc.  See remarks for more.  Default = 0.  It is suggested to leave at 0! 
EndEnumeration

Enumeration ; FMOD_DSP_CHORUS
  #FMOD_DSP_CHORUS_DRYMIX    ; Volume of original signal to pass to output.  0.0 to 1.0. Default = 0.5. 
  #FMOD_DSP_CHORUS_WETMIX1   ; Volume of 1st chorus tap.  0.0 to 1.0.  Default = 0.5. 
  #FMOD_DSP_CHORUS_WETMIX2   ; Volume of 2nd chorus tap. This tap is 90 degrees out of phase of the first tap.  0.0 to 1.0.  Default = 0.5. 
  #FMOD_DSP_CHORUS_WETMIX3   ; Volume of 3rd chorus tap. This tap is 90 degrees out of phase of the second tap.  0.0 to 1.0.  Default = 0.5. 
  #FMOD_DSP_CHORUS_DELAY     ; Chorus delay in ms.  0.1 to 100.0.  Default = 40.0 ms. 
  #FMOD_DSP_CHORUS_RATE      ; Chorus modulation rate in hz.  0.0 to 20.0.  Default = 0.8 hz. 
  #FMOD_DSP_CHORUS_DEPTH     ; Chorus modulation depth.  0.0 to 1.0.  Default = 0.03. 
  #FMOD_DSP_CHORUS_FEEDBACK  ; Chorus feedback.  Controls how much of the wet signal gets fed back into the chorus buffer.  0.0 to 1.0.  Default = 0.0. 
EndEnumeration

Enumeration ; FMOD_DSP_REVERB
  #FMOD_DSP_REVERB_ROOMSIZE  ; Roomsize. 0.0 to 1.0.  Default = 0.5 
  #FMOD_DSP_REVERB_DAMP      ; Damp.     0.0 to 1.0.  Default = 0.5 
  #FMOD_DSP_REVERB_WETMIX    ; Wet mix.  0.0 to 1.0.  Default = 0.33 
  #FMOD_DSP_REVERB_DRYMIX    ; Dry mix.  0.0 to 1.0.  Default = 0.0 
  #FMOD_DSP_REVERB_WIDTH     ; Width.    0.0 to 1.0.  Default = 1.0 
  #FMOD_DSP_REVERB_MODE      ; Mode.     0 (normal), 1 (freeze).  Default = 0 
EndEnumeration

Enumeration ; FMOD_DSP_ITECHO
  #FMOD_DSP_ITECHO_WETDRYMIX      ; Ratio of wet (processed) signal to dry (unprocessed) signal. Must be in the range from 0.0 through 100.0 (all wet). The default value is 50. 
  #FMOD_DSP_ITECHO_FEEDBACK       ; Percentage of output fed back into input, in the range from 0.0 through 100.0. The default value is 50. 
  #FMOD_DSP_ITECHO_LEFTDELAY      ; Delay for left channel, in milliseconds, in the range from 1.0 through 2000.0. The default value is 500 ms. 
  #FMOD_DSP_ITECHO_RIGHTDELAY     ; Delay for right channel, in milliseconds, in the range from 1.0 through 2000.0. The default value is 500 ms. 
  #FMOD_DSP_ITECHO_PANDELAY       ; Value that specifies whether to swap left and right delays with each successive echo. The default value is zero, meaning no swap. Possible values are defined as 0.0 (equivalent to FALSE) and 1.0 (equivalent to TRUE). 
EndEnumeration

Enumeration ; FMOD_DSP_COMPRESSOR
  #FMOD_DSP_COMPRESSOR_THRESHOLD   ; Threshold level (dB)in the range from -60 through 0. The default value is 50. 
  #FMOD_DSP_COMPRESSOR_ATTACK      ; Gain reduction attack time (milliseconds), in the range from 10 through 200. The default value is 50. 
  #FMOD_DSP_COMPRESSOR_RELEASE     ; Gain reduction release time (milliseconds), in the range from 20 through 1000. The default value is 50. 
  #FMOD_DSP_COMPRESSOR_GAINMAKEUP  ; Make-up gain applied after limiting, in the range from 0.0 through 100.0. The default value is 50. 
EndEnumeration

Enumeration ; FMOD_DSP_SFXREVERB
  #FMOD_DSP_SFXREVERB_DRYLEVEL             ; Dry Level      : Mix level of dry signal in output in mB.  Ranges from -10000.0 to 0.0.  Default is 0.0. 
  #FMOD_DSP_SFXREVERB_ROOM                 ; Room           : Room effect level at low frequencies in mB.  Ranges from -10000.0 to 0.0.  Default is 0.0. 
  #FMOD_DSP_SFXREVERB_ROOMHF               ; Room HF        : Room effect high-frequency level re. low frequency level in mB.  Ranges from -10000.0 to 0.0.  Default is 0.0. 
  #FMOD_DSP_SFXREVERB_ROOMROLLOFFFACTOR    ; Room Rolloff   : Like DS3D flRolloffFactor but for room effect.  Ranges from 0.0 to 10.0. Default is 10.0 
  #FMOD_DSP_SFXREVERB_DECAYTIME            ; Decay Time     : Reverberation decay time at low-frequencies in seconds.  Ranges from 0.1 to 20.0. Default is 1.0. 
  #FMOD_DSP_SFXREVERB_DECAYHFRATIO         ; Decay HF Ratio : High-frequency to low-frequency decay time ratio.  Ranges from 0.1 to 2.0. Default is 0.5. 
  #FMOD_DSP_SFXREVERB_REFLECTIONSLEVEL     ; Reflections    : Early reflections level relative to room effect in mB.  Ranges from -10000.0 to 1000.0.  Default is -10000.0. 
  #FMOD_DSP_SFXREVERB_REFLECTIONSDELAY     ; Reflect Delay  : Delay time of first reflection in seconds.  Ranges from 0.0 to 0.3.  Default is 0.02. 
  #FMOD_DSP_SFXREVERB_REVERBLEVEL          ; Reverb         : Late reverberation level relative to room effect in mB.  Ranges from -10000.0 to 2000.0.  Default is 0.0. 
  #FMOD_DSP_SFXREVERB_REVERBDELAY          ; Reverb Delay   : Late reverberation delay time relative to first reflection in seconds.  Ranges from 0.0 to 0.1.  Default is 0.04. 
  #FMOD_DSP_SFXREVERB_DIFFUSION            ; Diffusion      : Reverberation diffusion (echo density) in percent.  Ranges from 0.0 to 100.0.  Default is 100.0. 
  #FMOD_DSP_SFXREVERB_DENSITY              ; Density        : Reverberation density (modal density) in percent.  Ranges from 0.0 to 100.0.  Default is 100.0. 
  #FMOD_DSP_SFXREVERB_HFREFERENCE          ; HF Reference   : Reference high frequency in Hz.  Ranges from 20.0 to 20000.0. Default is 5000.0. 
EndEnumeration

Enumeration ; FMOD_DSP_LOWPASS_SIMPLE
  #FMOD_DSP_LOWPASS_SIMPLE_CUTOFF     ; Lowpass cutoff frequency in hz.  10.0 to 22000.0.  Default = 5000.0 
EndEnumeration




;-#############################
;-############################# from fmodex
;-#############################

#FMOD_VERSION  = $40606

Structure FMOD_VECTOR
  x.f 
  y.f 
  z.f 
EndStructure

Enumeration ; FMOD_RESULT
  #FMOD_OK                         ; No errors.
  #FMOD_ERR_ALREADYLOCKED          ; Tried to call lock a second time before unlock was called.
  #FMOD_ERR_BADCOMMAND             ; Tried to call a function on a data type that does not allow this type of functionality (ie calling Sound::lock on a streaming sound).
  #FMOD_ERR_CDDA_DRIVERS           ; Neither NTSCSI nor ASPI could be initialised.
  #FMOD_ERR_CDDA_INIT              ; An error occurred while initialising the CDDA subsystem.
  #FMOD_ERR_CDDA_INVALID_DEVICE    ; Couldn't find the specified device.
  #FMOD_ERR_CDDA_NOAUDIO           ; No audio tracks on the specified disc.
  #FMOD_ERR_CDDA_NODEVICES         ; No CD/DVD devices were found.
  #FMOD_ERR_CDDA_NODISC            ; No disc present in the specified drive.
  #FMOD_ERR_CDDA_READ              ; A CDDA read error occurred.
  #FMOD_ERR_CHANNEL_ALLOC          ; Error trying to allocate a channel.
  #FMOD_ERR_CHANNEL_STOLEN         ; The specified channel has been reused to play another sound.
  #FMOD_ERR_COM                    ; A Win32 COM related error occured. COM failed to initialize or a QueryInterface failed meaning a Windows codec or driver was not installed properly.
  #FMOD_ERR_DMA                    ; DMA Failure.  See debug output for more information.
  #FMOD_ERR_DSP_CONNECTION         ; DSP connection error.  Connection possibly caused a cyclic dependancy.
  #FMOD_ERR_DSP_FORMAT             ; DSP Format error.  A DSP unit may have attempted to connect to this network with the wrong format.
  #FMOD_ERR_DSP_NOTFOUND           ; DSP connection error.  Couldn't find the DSP unit specified.
  #FMOD_ERR_DSP_RUNNING            ; DSP error.  Cannot perform this operation while the network is in the middle of running.  This will most likely happen if a connection or disconnection is attempted in a DSP callback.
  #FMOD_ERR_DSP_TOOMANYCONNECTIONS ; DSP connection error.  The unit being connected to or disconnected should only have 1 input or output.
  #FMOD_ERR_FILE_BAD               ; Error loading file.
  #FMOD_ERR_FILE_COULDNOTSEEK      ; Couldn't perform seek operation.  This is a limitation of the medium (ie netstreams) or the file format.
  #FMOD_ERR_FILE_EOF               ; End of file unexpectedly reached while trying to read essential data (truncated data?).
  #FMOD_ERR_FILE_NOTFOUND          ; File not found.
  #FMOD_ERR_FILE_UNWANTED          ; Unwanted file access occured.
  #FMOD_ERR_FORMAT                 ; Unsupported file or audio format.
  #FMOD_ERR_HTTP                   ; A HTTP error occurred. This is a catch-all for HTTP errors not listed elsewhere.
  #FMOD_ERR_HTTP_ACCESS            ; The specified resource requires authentication or is forbidden.
  #FMOD_ERR_HTTP_PROXY_AUTH        ; Proxy authentication is required to access the specified resource.
  #FMOD_ERR_HTTP_SERVER_ERROR      ; A HTTP server error occurred.
  #FMOD_ERR_HTTP_TIMEOUT           ; The HTTP request timed out.
  #FMOD_ERR_INITIALIZATION         ; FMOD was not initialized correctly to support this function.
  #FMOD_ERR_INITIALIZED            ; Cannot call this command after System::init.
  #FMOD_ERR_INTERNAL               ; An error occured that wasnt supposed to.  Contact support.
  #FMOD_ERR_INVALID_ADDRESS        ; On Xbox 360, this memory address passed to FMOD must be physical, (ie allocated with XPhysicalAlloc.)
  #FMOD_ERR_INVALID_FLOAT          ; Value passed in was a NaN, Inf or denormalized float.
  #FMOD_ERR_INVALID_HANDLE         ; An invalid object handle was used.
  #FMOD_ERR_INVALID_PARAM          ; An invalid parameter was passed to this function.
  #FMOD_ERR_INVALID_SPEAKER        ; An invalid speaker was passed to this function based on the current speaker mode.
  #FMOD_ERR_INVALID_VECTOR         ; The vectors passed in are not unit length, or perpendicular.
  #FMOD_ERR_IRX                    ; PS2 only.  fmodex.irx failed to initialize.  This is most likely because you forgot to load it.
  #FMOD_ERR_MEMORY                 ; Not enough memory or resources.
  #FMOD_ERR_MEMORY_IOP             ; PS2 only.  Not enough memory or resources on PlayStation 2 IOP ram.
  #FMOD_ERR_MEMORY_SRAM            ; Not enough memory or resources on console sound ram.
  #FMOD_ERR_MEMORY_CANTPOINT       ; Can't use #FMOD_OPENMEMORY_POINT on non PCM source data, or non mp3/xma/adpcm data if #FMOD_CREATECOMPRESSEDSAMPLE was used.
  #FMOD_ERR_NEEDS2D                ; Tried to call a command on a 3d sound when the command was meant for 2d sound.
  #FMOD_ERR_NEEDS3D                ; Tried to call a command on a 2d sound when the command was meant for 3d sound.
  #FMOD_ERR_NEEDSHARDWARE          ; Tried to use a feature that requires hardware support.  (ie trying to play a VAG compressed sound in software on PS2).
  #FMOD_ERR_NEEDSSOFTWARE          ; Tried to use a feature that requires the software engine.  Software engine has either been turned off or command was executed on a hardware channel which does not support this feature.
  #FMOD_ERR_NET_CONNECT            ; Couldn't connect to the specified host.
  #FMOD_ERR_NET_SOCKET_ERROR       ; A socket error occurred.  This is a catch-all for socket-related errors not listed elsewhere.
  #FMOD_ERR_NET_URL                ; The specified URL couldn't be resolved.
  #FMOD_ERR_NOTREADY               ; Operation could not be performed because specified sound is not ready.
  #FMOD_ERR_OUTPUT_ALLOCATED       ; Error initializing output device, but more specifically, the output device is already in use and cannot be reused.
  #FMOD_ERR_OUTPUT_CREATEBUFFER    ; Error creating hardware sound buffer.
  #FMOD_ERR_OUTPUT_DRIVERCALL      ; A call to a standard soundcard driver failed, which could possibly mean a bug in the driver or resources were missing or exhausted.
  #FMOD_ERR_OUTPUT_FORMAT          ; Soundcard does not support the minimum features needed for this soundsystem (16bit stereo output).
  #FMOD_ERR_OUTPUT_INIT            ; Error initializing output device.
  #FMOD_ERR_OUTPUT_NOHARDWARE      ; #FMOD_HARDWARE was specified but the sound card does not have the resources nescessary to play it.
  #FMOD_ERR_OUTPUT_NOSOFTWARE      ; Attempted to create a software sound but no software channels were specified in System::init.
  #FMOD_ERR_PAN                    ; Panning only works with mono or stereo sound sources.
  #FMOD_ERR_PLUGIN                 ; An unspecified error has been returned from a 3rd party plugin.
  #FMOD_ERR_PLUGIN_MISSING         ; A requested output, dsp unit type or codec was not available.
  #FMOD_ERR_PLUGIN_RESOURCE        ; A resource that the plugin requires cannot be found. (ie the DLS file for MIDI playback)
  #FMOD_ERR_RECORD                 ; An error occured trying to initialize the recording device.
  #FMOD_ERR_REVERB_INSTANCE        ; Specified Instance in #FMOD_REVERB_PROPERTIES couldn't be set. Most likely because another application has locked the EAX4 FX slot.
  #FMOD_ERR_SUBSOUNDS              ; The error occured because the sound referenced contains subsounds.  (ie you cannot play the parent sound as a static sample, only its subsounds.)
  #FMOD_ERR_SUBSOUND_ALLOCATED     ; This subsound is already being used by another sound, you cannot have more than one parent to a sound.  Null out the other parent's entry first.
  #FMOD_ERR_TAGNOTFOUND            ; The specified tag could not be found or there are no tags.
  #FMOD_ERR_TOOMANYCHANNELS        ; The sound created exceeds the allowable input channel count.  This can be increased using the maxinputchannels parameter in System::setSoftwareFormat.
  #FMOD_ERR_UNIMPLEMENTED          ; Something in FMOD hasn't been implemented when it should be! contact support!
  #FMOD_ERR_UNINITIALIZED          ; This command failed because System::init or System::setDriver was not called.
  #FMOD_ERR_UNSUPPORTED            ; A command issued was not supported by this object.  Possibly a plugin without certain callbacks specified.
  #FMOD_ERR_UPDATE                 ; On PS2, System::update was called twice in a row when System::updateFinished must be called first.
  #FMOD_ERR_VERSION                ; The version number of this file format is not supported.
  
  #FMOD_ERR_EVENT_FAILED           ; An Event failed to be retrieved, most likely due to "just fail" being specified as the max playbacks behaviour.
  #FMOD_ERR_EVENT_INTERNAL         ; An error occured that wasn't supposed to.  See debug log for reason.
  #FMOD_ERR_EVENT_NAMECONFLICT     ; A category with the same name already exists.
  #FMOD_ERR_EVENT_NOTFOUND         ; The requested event, event group, event category or event property could not be found.
EndEnumeration

Enumeration ; FMOD_OUTPUTTYPE
  #FMOD_OUTPUTTYPE_AUTODETECT    ; Picks the best output mode for the platform.  This is the default.
  
  #FMOD_OUTPUTTYPE_UNKNOWN       ; All         - 3rd party plugin, unknown.  This is for use with System::getOutput only.
  #FMOD_OUTPUTTYPE_NOSOUND       ; All         - All calls in this mode succeed but make no sound.
  #FMOD_OUTPUTTYPE_WAVWRITER     ; All         - Writes output to fmodout.wav by default.  Use System::setSoftwareFormat to set the filename.
  #FMOD_OUTPUTTYPE_NOSOUND_NRT   ; All         - Non-realtime version of #FMOD_OUTPUTTYPE_NOSOUND.  User can drive mixer with System::update at whatever rate they want. 
  #FMOD_OUTPUTTYPE_WAVWRITER_NRT ; All         - Non-realtime version of #FMOD_OUTPUTTYPE_WAVWRITER.  User can drive mixer with System::update at whatever rate they want. 
  
  #FMOD_OUTPUTTYPE_DSOUND        ; Win32/Win64 - DirectSound output.  Use this to get hardware accelerated 3d audio and EAX Reverb support. (Default on Windows)
  #FMOD_OUTPUTTYPE_WINMM         ; Win32/Win64 - Windows Multimedia output.
  #FMOD_OUTPUTTYPE_ASIO          ; Win32       - Low latency ASIO driver.
  #FMOD_OUTPUTTYPE_OSS           ; Linux       - Open Sound System output.
  #FMOD_OUTPUTTYPE_ALSA          ; Linux       - Advanced Linux Sound Architecture output.
  #FMOD_OUTPUTTYPE_ESD           ; Linux       - Enlightment Sound Daemon output.
  #FMOD_OUTPUTTYPE_SOUNDMANAGER  ; Mac         - Macintosh SoundManager output.
  #FMOD_OUTPUTTYPE_COREAUDIO     ; Mac         - Macintosh CoreAudio output.
  #FMOD_OUTPUTTYPE_XBOX          ; Xbox        - Native hardware output.
  #FMOD_OUTPUTTYPE_PS2           ; PS2         - Native hardware output.
  #FMOD_OUTPUTTYPE_GC            ; GameCube    - Native hardware output.
  #FMOD_OUTPUTTYPE_XBOX360       ; Xbox 360    - Native hardware output.
  #FMOD_OUTPUTTYPE_PSP           ; PSP         - Native hardware output.
  #FMOD_OUTPUTTYPE_OPENAL        ; Win32/Win64 - OpenAL 1.1 output. Use this for lower CPU overhead than #FMOD_OUTPUTTYPE_DSOUND, and also Vista H/W support with Creative Labs cards.
  
  #FMOD_OUTPUTTYPE_MAX           ; Maximum number of output types supported. 
EndEnumeration

Enumeration ; FMOD_CAPS
  #FMOD_CAPS_NONE = $0                             ; Device has no special capabilities.
  #FMOD_CAPS_HARDWARE = $1                         ; Device supports hardware mixing.
  #FMOD_CAPS_HARDWARE_EMULATED = $2                ; Device supports #FMOD_HARDWARE but it will be mixed on the CPU by the kernel (not FMOD's software mixer).
  #FMOD_CAPS_OUTPUT_MULTICHANNEL = $4              ; Device can do multichannel output, ie greater than 2 channels.
  #FMOD_CAPS_OUTPUT_FORMAT_PCM8 = $8               ; Device can output to 8bit integer PCM.
  #FMOD_CAPS_OUTPUT_FORMAT_PCM16 = $10             ; Device can output to 16bit integer PCM.
  #FMOD_CAPS_OUTPUT_FORMAT_PCM24 = $20             ; Device can output to 24bit integer PCM.
  #FMOD_CAPS_OUTPUT_FORMAT_PCM32 = $40             ; Device can output to 32bit integer PCM.
  #FMOD_CAPS_OUTPUT_FORMAT_PCMFLOAT = $80          ; Device can output to 32bit floating point PCM.
  #FMOD_CAPS_REVERB_EAX2 = $100                    ; Device supports EAX2 reverb.
  #FMOD_CAPS_REVERB_EAX3 = $200                    ; Device supports EAX3 reverb.
  #FMOD_CAPS_REVERB_EAX4 = $400                    ; Device supports EAX4 reverb  
  #FMOD_CAPS_REVERB_I3DL2 = $800                   ; Device supports I3DL2 reverb.
  #FMOD_CAPS_REVERB_LIMITED = $1000                ; Device supports some form of limited hardware reverb, maybe parameterless and only selectable by environment.
EndEnumeration

Enumeration ; FMOD_DEBUGLEVEL
  #FMOD_DEBUG_LEVEL_NONE = $0
  #FMOD_DEBUG_LEVEL_LOG = $1
  #FMOD_DEBUG_LEVEL_ERROR = $2
  #FMOD_DEBUG_LEVEL_WARNING = $4
  #FMOD_DEBUG_LEVEL_HINT = $8
  #FMOD_DEBUG_LEVEL_ALL = $FF
  #FMOD_DEBUG_TYPE_MEMORY = $100
  #FMOD_DEBUG_TYPE_THREAD = $200
  #FMOD_DEBUG_TYPE_FILE = $400
  #FMOD_DEBUG_TYPE_NET = $800
  #FMOD_DEBUG_TYPE_EVENT = $1000
  #FMOD_DEBUG_TYPE_ALL = $FFFF
  #FMOD_DEBUG_DISPLAY_TIMESTAMPS = $1000000
  #FMOD_DEBUG_DISPLAY_LINENUMBERS = $2000000
  #FMOD_DEBUG_DISPLAY_COMPRESS = $4000000
  #FMOD_DEBUG_DISPLAY_ALL = $F000000
  #FMOD_DEBUG_ALL = $FFFFFFFF
EndEnumeration

Enumeration ; FMOD_MEMORY_TYPE
  #FMOD_MEMORY_NORMAL = $0                   ; Standard memory.
  #FMOD_MEMORY_XBOX360_PHYSICAL = $100000    ; Requires XPhysicalAlloc / XPhysicalFree.
EndEnumeration

Enumeration ; FMOD_SPEAKERMODE
  #FMOD_SPEAKERMODE_RAW              ; There is no specific speakermode.  Sound channels are mapped in order of input to output.  See remarks for more information.
  #FMOD_SPEAKERMODE_MONO             ; The speakers are monaural.
  #FMOD_SPEAKERMODE_STEREO           ; The speakers are stereo (DEFAULT).
  #FMOD_SPEAKERMODE_QUAD             ; 4 speaker setup.  This includes front left, front right, rear left, rear right.
  #FMOD_SPEAKERMODE_SURROUND         ; 4 speaker setup.  This includes front left, front right, center, rear center (rear left/rear right are averaged).
  #FMOD_SPEAKERMODE_5POINT1          ; 5.1 speaker setup.  This includes front left, front right, center, rear left, rear right and a subwoofer.
  #FMOD_SPEAKERMODE_7POINT1          ; 7.1 speaker setup.  This includes front left, front right, center, rear left, rear right, side left, side right and a subwoofer.
  #FMOD_SPEAKERMODE_PROLOGIC         ; Stereo output, but data is encoded in a way that is picked up by a Prologic/Prologic2 decoder and split into a 5.1 speaker setup.
  
  #FMOD_SPEAKERMODE_MAX              ; Maximum number of speaker modes supported.
EndEnumeration

Enumeration ; FMOD_SPEAKER
  #FMOD_SPEAKER_FRONT_LEFT
  #FMOD_SPEAKER_FRONT_RIGHT
  #FMOD_SPEAKER_FRONT_CENTER
  #FMOD_SPEAKER_LOW_FREQUENCY
  #FMOD_SPEAKER_BACK_LEFT
  #FMOD_SPEAKER_BACK_RIGHT
  #FMOD_SPEAKER_SIDE_LEFT
  #FMOD_SPEAKER_SIDE_RIGHT
  
  #FMOD_SPEAKER_MAX                                       ; Maximum number of speaker types supported.
  #FMOD_SPEAKER_MONO = #FMOD_SPEAKER_FRONT_LEFT            ; For use with #FMOD_SPEAKERMODE_MONO and Channel::SetSpeakerLevels.  Mapped to same value as #FMOD_SPEAKER_FRONT_LEFT.
  #FMOD_SPEAKER_BACK_CENTER = #FMOD_SPEAKER_LOW_FREQUENCY  ; For use with #FMOD_SPEAKERMODE_SURROUND and Channel::SetSpeakerLevels only.  Mapped to same value as #FMOD_SPEAKER_LOW_FREQUENCY.
EndEnumeration

Enumeration ; FMOD_PLUGINTYPE
  #FMOD_PLUGINTYPE_OUTPUT     ; The plugin type is an output module.  FMOD mixed audio will play through one of these devices.
  #FMOD_PLUGINTYPE_CODEC      ; The plugin type is a file format codec.  FMOD will use these codecs to load file formats for playback.
  #FMOD_PLUGINTYPE_DSP        ; The plugin type is a DSP unit.  FMOD will use these plugins as part of its DSP network to apply effects to output or generate sound in realtime.
EndEnumeration

Enumeration ; FMOD_INITFLAGS
  #FMOD_INIT_NORMAL = $0                           ; All platforms - Initialize normally.
  #FMOD_INIT_STREAM_FROM_UPDATE = $1               ; All platforms - No stream thread is created internally.  Streams are driven from System::update.  Mainly used with non-realtime outputs. 
  #FMOD_INIT_3D_RIGHTHANDED = $2                   ; All platforms - FMOD will treat +X as left, +Y as up and +Z as forwards.
  #FMOD_INIT_DISABLESOFTWARE = $4                  ; All platforms - Disable software mixer to save memory.  Anything created with #FMOD_SOFTWARE will fail and DSP will not work.
  #FMOD_INIT_DSOUND_HRTFNONE = $200                ; Win32 only - for DirectSound output - #FMOD_HARDWARE | #FMOD_3D buffers use simple stereo panning/doppler/attenuation when 3D hardware acceleration is not present.
  #FMOD_INIT_DSOUND_HRTFLIGHT = $400               ; Win32 only - for DirectSound output - #FMOD_HARDWARE | #FMOD_3D buffers use a slightly higher quality algorithm when 3D hardware acceleration is not present.
  #FMOD_INIT_DSOUND_HRTFFULL = $800                ; Win32 only - for DirectSound output - #FMOD_HARDWARE | #FMOD_3D buffers use full quality 3D playback when 3d hardware acceleration is not present.
  #FMOD_INIT_PS2_DISABLECORE0REVERB = $10000       ; PS2 only - Disable reverb on CORE 0 to regain SRAM.
  #FMOD_INIT_PS2_DISABLECORE1REVERB = $20000       ; PS2 only - Disable reverb on CORE 1 to regain SRAM.
  #FMOD_INIT_XBOX_REMOVEHEADROOM = $100000         ; XBox only - By default DirectSound attenuates all sound by 6db to avoid clipping/distortion.  CAUTION.  If you use this flag you are responsible for the final mix to make sure clipping / distortion doesn't happen.
EndEnumeration

Enumeration ; FMOD_SOUND_TYPE
  #FMOD_SOUND_TYPE_UNKNOWN         ; 3rd party / unknown plugin format.
  #FMOD_SOUND_TYPE_AAC             ; AAC.  Currently unsupported.
  #FMOD_SOUND_TYPE_AIFF            ; AIFF.
  #FMOD_SOUND_TYPE_ASF             ; Microsoft Advanced Systems Format (ie WMA/ASF/WMV).
  #FMOD_SOUND_TYPE_AT3             ; Sony ATRAC 3 format
  #FMOD_SOUND_TYPE_CDDA            ; Digital CD audio.
  #FMOD_SOUND_TYPE_DLS             ; Sound font / downloadable sound bank.
  #FMOD_SOUND_TYPE_FLAC            ; FLAC lossless codec.
  #FMOD_SOUND_TYPE_FSB             ; FMOD Sample Bank.
  #FMOD_SOUND_TYPE_GCADPCM         ; GameCube ADPCM
  #FMOD_SOUND_TYPE_IT              ; Impulse Tracker.
  #FMOD_SOUND_TYPE_MIDI            ; MIDI.
  #FMOD_SOUND_TYPE_MOD             ; Protracker / Fasttracker MOD.
  #FMOD_SOUND_TYPE_MPEG            ; MP2/MP3 MPEG.
  #FMOD_SOUND_TYPE_OGGVORBIS       ; Ogg vorbis.
  #FMOD_SOUND_TYPE_PLAYLIST        ; Information only from ASX/PLS/M3U/WAX playlists
  #FMOD_SOUND_TYPE_RAW             ; Raw PCM data.
  #FMOD_SOUND_TYPE_S3M             ; ScreamTracker 3.
  #FMOD_SOUND_TYPE_SF2             ; Sound font 2 format.
  #FMOD_SOUND_TYPE_USER            ; User created sound.
  #FMOD_SOUND_TYPE_WAV             ; Microsoft WAV.
  #FMOD_SOUND_TYPE_XM              ; FastTracker 2 XM.
  #FMOD_SOUND_TYPE_XMA             ; Xbox360 XMA
  #FMOD_SOUND_TYPE_VAG             ; PlayStation 2 / PlayStation Portable adpcm VAG format.
EndEnumeration

Enumeration ; FMOD_SOUND_FORMAT
  #FMOD_SOUND_FORMAT_NONE      ; Unitialized / unknown.
  #FMOD_SOUND_FORMAT_PCM8      ; 8bit integer PCM data.
  #FMOD_SOUND_FORMAT_PCM16     ; 16bit integer PCM data.
  #FMOD_SOUND_FORMAT_PCM24     ; 24bit integer PCM data.
  #FMOD_SOUND_FORMAT_PCM32     ; 32bit integer PCM data.
  #FMOD_SOUND_FORMAT_PCMFLOAT  ; 32bit floating point PCM data.
  #FMOD_SOUND_FORMAT_GCADPCM   ; Compressed GameCube DSP data.
  #FMOD_SOUND_FORMAT_IMAADPCM  ; Compressed XBox ADPCM data.
  #FMOD_SOUND_FORMAT_VAG       ; Compressed PlayStation 2 ADPCM data.
  #FMOD_SOUND_FORMAT_XMA       ; Compressed Xbox360 data.
  #FMOD_SOUND_FORMAT_MPEG      ; Compressed MPEG layer 2 or 3 data.
  #FMOD_SOUND_FORMAT_MAX       ; Maximum number of sound formats supported.
EndEnumeration

Enumeration ; FMOD_MODE
  #FMOD_DEFAULT = $0                       ; #FMOD_DEFAULT is a default sound type.  Equivalent to all the defaults listed below.  #FMOD_LOOP_OFF, #FMOD_2D, #FMOD_HARDWARE.
  #FMOD_LOOP_OFF = $1                      ; For non looping sounds. (default).  Overrides #FMOD_LOOP_NORMAL / #FMOD_LOOP_BIDI.
  #FMOD_LOOP_NORMAL = $2                   ; For forward looping sounds.
  #FMOD_LOOP_BIDI = $4                     ; For bidirectional looping sounds. (only works on software mixed static sounds).
  #FMOD_2D = $8                            ; Ignores any 3d processing. (default).
  #FMOD_3D = $10                           ; Makes the sound positionable in 3D.  Overrides #FMOD_2D.
  #FMOD_HARDWARE = $20                     ; Attempts to make sounds use hardware acceleration. (default).
  #FMOD_SOFTWARE = $40                     ; Makes sound reside in software.  Overrides #FMOD_HARDWARE.  Use this for FFT,  DSP, 2D multi speaker support and other software related features.
  #FMOD_CREATESTREAM = $80                 ; Decompress at runtime, streaming from the source provided (standard stream).  Overrides #FMOD_CREATESAMPLE.
  #FMOD_CREATESAMPLE = $100                ; Decompress at loadtime, decompressing or decoding whole file into memory as the target sample format. (standard sample).
  #FMOD_CREATECOMPRESSEDSAMPLE = $200      ; Load MP2, MP3, IMAADPCM or XMA into memory and leave it compressed.  During playback the FMOD software mixer will decode it in realtime as a 'compressed sample'.  Can only be used in combination with #FMOD_SOFTWARE.
  #FMOD_OPENUSER = $400                    ; Opens a user created static sample or stream. Use #FMOD_CREATESOUNDEXINFO to specify format and/or read callbacks.  If a user created 'sample' is created with no read callback, the sample will be empty.  Use #FMOD_Sound_Lock and #FMOD_Sound_Unlock to place sound data into the sound if this is the case.
  #FMOD_OPENMEMORY = $800                  ; "name_or_data" will be interpreted as a pointer to memory instead of filename for creating sounds.
  #FMOD_OPENRAW = $1000                    ; Will ignore file format and treat as raw pcm.  User may need to declare if data is #FMOD_SIGNED or #FMOD_UNSIGNED 
  #FMOD_OPENONLY = $2000                   ; Just open the file, dont prebuffer or read.  Good for fast opens for info, or when #FMOD_Sound_ReadData is to be used.
  #FMOD_ACCURATETIME = $4000               ; For #FMOD_System_CreateSound - for accurate #FMOD_Sound_GetLength / #FMOD_Channel_SetPosition on VBR MP3, AAC and MOD/S3M/XM/IT/MIDI files.  Scans file first, so takes longer to open. #FMOD_OPENONLY does not affect this.
  #FMOD_MPEGSEARCH = $8000                 ; For corrupted / bad MP3 files.  This will search all the way through the file until it hits a valid MPEG header.  Normally only searches for 4k.
  #FMOD_NONBLOCKING = $10000               ; For opening sounds asyncronously, return value from open function must be polled for when it is ready.
  #FMOD_UNIQUE = $20000                    ; Unique sound, can only be played one at a time 
  #FMOD_3D_HEADRELATIVE = $40000           ; Make the sound's position, velocity and orientation relative to the listener.
  #FMOD_3D_WORLDRELATIVE = $80000          ; Make the sound's position, velocity and orientation absolute (relative to the world). (DEFAULT)
  #FMOD_3D_LOGROLLOFF = $100000            ; This sound will follow the standard logarithmic rolloff model where mindistance = full volume, maxdistance = where sound stops attenuating, and rolloff is fixed according to the global rolloff factor.  (default)
  #FMOD_3D_LINEARROLLOFF = $200000         ; This sound will follow a linear rolloff model where mindistance = full volume, maxdistance = silence.
  #FMOD_3D_CUSTOMROLLOFF = $4000000        ; This sound will follow a rolloff model defined by #FMOD_Sound_Set3DCustomRolloff / #FMOD_Channel_Set3DCustomRolloff.
  #FMOD_CDDA_FORCEASPI = $400000           ; For CDDA sounds only - use ASPI instead of NTSCSI to access the specified CD/DVD device.
  #FMOD_CDDA_JITTERCORRECT = $800000       ; For CDDA sounds only - perform jitter correction. Jitter correction helps produce a more accurate CDDA stream at the cost of more CPU time.
  #FMOD_UNICODE = $1000000                 ; Filename is double-byte unicode.
  #FMOD_IGNORETAGS = $2000000              ; Skips id3v2/asf/etc tag checks when opening a sound, to reduce seek/read overhead when opening files (helps with CD performance).
  #FMOD_LOWMEM = $8000000                  ; Removes some features from samples to give a lower memory overhead, like #FMOD_Sound_GetName.
EndEnumeration

Enumeration ; FMOD_OPENSTATE
  #FMOD_OPENSTATE_READY = 0        ; Opened and ready to play 
  #FMOD_OPENSTATE_LOADING          ; Initial load in progress 
  #FMOD_OPENSTATE_ERROR            ; Failed to open - file not found, out of memory etc.  See return value of Sound::getOpenState for what happened.
  #FMOD_OPENSTATE_CONNECTING       ; Connecting to remote host (internet sounds only) 
  #FMOD_OPENSTATE_BUFFERING        ; Buffering data 
EndEnumeration

Enumeration ; FMOD_CHANNEL_CALLBACKTYPE
  #FMOD_CHANNEL_CALLBACKTYPE_END                  ; Called when a sound ends.
  #FMOD_CHANNEL_CALLBACKTYPE_VIRTUALVOICE         ; Called when a voice is swapped out or swapped in.
  #FMOD_CHANNEL_CALLBACKTYPE_SYNCPOINT            ; Called when a syncpoint is encountered.  Can be from wav file markers.
  
  #FMOD_CHANNEL_CALLBACKTYPE_MAX
EndEnumeration

Enumeration ; FMOD_DSP_FFT_WINDOW
  #FMOD_DSP_FFT_WINDOW_RECT            ; w[n] = 1.0                                                                                            
  #FMOD_DSP_FFT_WINDOW_TRIANGLE        ; w[n] = TRI(2n/N)                                                                                      
  #FMOD_DSP_FFT_WINDOW_HAMMING         ; w[n] = 0.54 - (0.46 * COS(n/N) )                                                                      
  #FMOD_DSP_FFT_WINDOW_HANNING         ; w[n] = 0.5 *  (1.0  - COS(n/N) )                                                                      
  #FMOD_DSP_FFT_WINDOW_BLACKMAN        ; w[n] = 0.42 - (0.5  * COS(n/N) ) + (0.08 * COS(2.0 * n/N) )                                           
  #FMOD_DSP_FFT_WINDOW_BLACKMANHARRIS  ; w[n] = 0.35875 - (0.48829 * COS(1.0 * n/N)) + (0.14128 * COS(2.0 * n/N)) - (0.01168 * COS(3.0 * n/N)) 
  #FMOD_DSP_FFT_WINDOW_MAX
EndEnumeration

Enumeration ; FMOD_DSP_RESAMPLER
  #FMOD_DSP_RESAMPLER_NOINTERP        ; No interpolation.  High frequency aliasing hiss will be audible depending on the sample rate of the sound. 
  #FMOD_DSP_RESAMPLER_LINEAR          ; Linear interpolation (default method).  Fast and good quality, causes very slight lowpass effect on low frequency sounds. 
  #FMOD_DSP_RESAMPLER_CUBIC           ; Cubic interoplation.  Slower than linear interpolation but better quality. 
  #FMOD_DSP_RESAMPLER_SPLINE          ; 5 point spline interoplation.  Slowest resampling method but best quality. 
  
  #FMOD_DSP_RESAMPLER_MAX             ; Maximum number of resample methods supported. 
EndEnumeration

Enumeration ; FMOD_TAGTYPE
  #FMOD_TAGTYPE_UNKNOWN = 0
  #FMOD_TAGTYPE_ID3V1
  #FMOD_TAGTYPE_ID3V2
  #FMOD_TAGTYPE_VORBISCOMMENT
  #FMOD_TAGTYPE_SHOUTCAST
  #FMOD_TAGTYPE_ICECAST
  #FMOD_TAGTYPE_ASF
  #FMOD_TAGTYPE_MIDI
  #FMOD_TAGTYPE_PLAYLIST
  #FMOD_TAGTYPE_FMOD
  #FMOD_TAGTYPE_USER
EndEnumeration

Enumeration ; FMOD_TAGDATATYPE
  #FMOD_TAGDATATYPE_BINARY = 0
  #FMOD_TAGDATATYPE_INT
  #FMOD_TAGDATATYPE_FLOAT
  #FMOD_TAGDATATYPE_STRING
  #FMOD_TAGDATATYPE_STRING_UTF16
  #FMOD_TAGDATATYPE_STRING_UTF16BE
  #FMOD_TAGDATATYPE_STRING_UTF8
  #FMOD_TAGDATATYPE_CDTOC
EndEnumeration

Structure FMOD_TAG
  type.l         ; [out] The type of this tag.
  datatype.l     ; [out] The type of data that this tag contains 
  name.l                      ; [out] The name of this tag i.e. "TITLE", "ARTIST" etc.
  _data.l                      ; [out] Pointer to the tag data - its format is determined by the datatype member 
  datalen.l                   ; [out] Length of the data contained in this tag 
  udated.l                 ; [out] True if this tag has been updated since last being accessed with Sound::getTag 
EndStructure

Structure FMOD_CDTOC
  numtracks.l                 ; [out] The number of tracks on the CD 
  min.l[100]                  ; [out] The start offset of each track in minutes 
  sec.l[100]                  ; [out] The start offset of each track in seconds 
  frame.l[100]                ; [out] The start offset of each track in frames 
EndStructure

Enumeration ; FMOD_TIMEUNIT
  #FMOD_TIMEUNIT_MS = $1                        ; Milliseconds.
  #FMOD_TIMEUNIT_PCM = $2                       ; PCM Samples, related to milliseconds * samplerate / 1000.
  #FMOD_TIMEUNIT_PCMBYTES = $4                  ; Bytes, related to PCM samples * channels * datawidth (ie 16bit = 2 bytes).
  #FMOD_TIMEUNIT_RAWBYTES = $8                  ; Raw file bytes of (compressed) sound data (does not include headers).  Only used by Sound::getLength and Channel::getPosition.
  #FMOD_TIMEUNIT_MODORDER = $100                ; MOD/S3M/XM/IT.  Order in a sequenced module format.  Use Sound::getFormat to determine the format.
  #FMOD_TIMEUNIT_MODROW = $200                  ; MOD/S3M/XM/IT.  Current row in a sequenced module format.  Sound::getLength will return the number if rows in the currently playing or seeked to pattern.
  #FMOD_TIMEUNIT_MODPATTERN = $400              ; MOD/S3M/XM/IT.  Current pattern in a sequenced module format.  Sound::getLength will return the number of patterns in the song and Channel::getPosition will return the currently playing pattern.
  #FMOD_TIMEUNIT_SENTENCE_MS = $10000           ; Currently playing subsound in a sentence time in milliseconds.
  #FMOD_TIMEUNIT_SENTENCE_PCM = $20000          ; Currently playing subsound in a sentence time in PCM Samples, related to milliseconds * samplerate / 1000.
  #FMOD_TIMEUNIT_SENTENCE_PCMBYTES = $40000     ; Currently playing subsound in a sentence time in bytes, related to PCM samples * channels * datawidth (ie 16bit = 2 bytes).
  #FMOD_TIMEUNIT_SENTENCE = $80000              ; Currently playing sentence index according to the channel.
  #FMOD_TIMEUNIT_SENTENCE_SUBSOUND = $100000    ; Currently playing subsound index in a sentence.
  #FMOD_TIMEUNIT_BUFFERED = $10000000           ; Time value as seen by buffered stream.  This is always ahead of audible time, and is only used for processing.
EndEnumeration

Structure FMOD_CREATESOUNDEXINFO
  cbSize.l                          ; [in] Size of this structure.  This is used so the structure can be expanded in the future and still work on older versions of FMOD Ex.
  Length.l                          ; [in] Optional. Specify 0 to ignore. Size in bytes of file to load, or sound to create (in this case only if FMOD_OPENUSER is used).  Required if loading from memory.  If 0 is specified, then it will use the size of the file (unless loading from memory then an error will be returned).
  fileoffset.l                      ; [in] Optional. Specify 0 to ignore. Offset from start of the file to start loading from.  This is useful for loading files from inside big data files.
  Numchannels.l                     ; [in] Optional. Specify 0 to ignore. Number of channels in a sound specified only if FMOD_OPENUSER is used.
  defaultfrequency.l                ; [in] Optional. Specify 0 to ignore. Default frequency of sound in a sound specified only if FMOD_OPENUSER is used.  Other formats use the frequency determined by the file format.
  Format.l ; [in] Optional. Specify 0 or FMOD_SOUND_FORMAT_NONE to ignore. Format of the sound specified only if FMOD_OPENUSER is used.  Other formats use the format determined by the file format.
  decodebuffersize.l                ; [in] Optional. Specify 0 to ignore. For streams.  This determines the size of the double buffer (in PCM samples) that a stream uses.  Use this for user created streams if you want to determine the size of the callback buffer passed to you.  Specify 0 to use FMOD's default size which is currently equivalent to 400ms of the sound format created/loaded.
  initialsubsound.l                 ; [in] Optional. Specify 0 to ignore. In a multi-sample file format such as .FSB/.DLS/.SF2, specify the initial subsound to seek to, only if FMOD_CREATESTREAM is used.
  Numsubsounds.l                    ; [in] Optional. Specify 0 to ignore or have no subsounds.  In a user created multi-sample sound, specify the number of subsounds within the sound that are accessable with Sound::getSubSound.
  inclusionlist.l                   ; [in] Optional. Specify 0 to ignore. In a multi-sample format such as .FSB/.DLS/.SF2 it may be desirable to specify only a subset of sounds to be loaded out of the whole file.  This is an array of subsound indicies to load into memory when created.
  inclusionlistnum.l                ; [in] Optional. Specify 0 to ignore. This is the number of integers contained within the inclusionlist array.
  pcmreadcallback.l                 ; [in] Optional. Specify 0 to ignore. Callback to 'piggyback' on FMOD's read functions and accept or even write PCM data while FMOD is opening the sound.  Used for user sounds created with FMOD_OPENUSER or for capturing decoded data as FMOD reads it.
  pcmsetposcallback.l               ; [in] Optional. Specify 0 to ignore. Callback for when the user calls a seeking function such as Channel::setTime or Channel::setPosition within a multi-sample sound, and for when it is opened.
  nonblockcallback.l                ; [in] Optional. Specify 0 to ignore. Callback for successful completion, or error while loading a sound that used the FMOD_NONBLOCKING flag.
  dlsname.s                       ; [in] Optional. Specify 0 to ignore. Filename for a DLS or SF2 sample set when loading a MIDI file.   If not specified, on windows it will attempt to open /windows/system32/drivers/gm.dls, otherwise the MIDI will fail to open.
  encryptionkey.s                 ; [in] Optional. Specify 0 to ignore. Key for encrypted FSB file.  Without this key an encrypted FSB file will not load.
  maxpolyphony.l                    ; [in] Optional. Specify 0 to ingore. For sequenced formats with dynamic channel allocation such as .MID and .IT, this specifies the maximum voice count allowed while playing.  .IT defaults to 64.  .MID defaults to 32.
  userdata.l                        ; [in] Optional. Specify 0 to ignore. This is user data to be attached to the sound during creation.  Access via Sound::getUserData. 
  suggestedsoundtype.l              ; [in] Optional. Specify 0 Or FMOD_SOUND_TYPE_UNKNOWN To ignore.  Instead of scanning all codec types, use this To speed up loading by making it jump straight To this codec.
  useropen.l                        ; [in] Optional. Specify 0 to ignore. Callback for opening this file.
  userclose.l                       ; [in] Optional. Specify 0 to ignore. Callback for closing this file.
  userread.l                        ; [in] Optional. Specify 0 to ignore. Callback for reading from this file.
  userseek.l                        ; [in] Optional. Specify 0 to ignore. Callback for seeking within this file.
EndStructure

#FMOD_CREATESOUNDEXINFO_SIZE  = 92 ;sizeof(#FMOD_CREATESOUNDEXINFO)

Structure FMOD_REVERB_PROPERTIES
  Instance.l                 ; [in]     0     , 2     , 0      , EAX4 only. Environment Instance. 3 seperate reverbs simultaneously are possible. This specifies which one to set. (win32 only) 
  Environment.l              ; [in/out] 0     , 25    , 0      , sets all listener properties (win32/ps2) 
  EnvSize.f                ; [in/out] 1.0   , 100.0 , 7.5    , environment size in meters (win32 only) 
  EnvDiffusion.f           ; [in/out] 0.0   , 1.0   , 1.0    , environment diffusion (win32/xbox) 
  Room.l                     ; [in/out] -10000, 0     , -1000  , room effect level (at mid frequencies) (win32/xbox) 
  RoomHF.l                   ; [in/out] -10000, 0     , -100   , relative room effect level at high frequencies (win32/xbox) 
  RoomLF.l                   ; [in/out] -10000, 0     , 0      , relative room effect level at low frequencies (win32 only) 
  DecayTime.f              ; [in/out] 0.1   , 20.0  , 1.49   , reverberation decay time at mid frequencies (win32/xbox) 
  DecayHFRatio.f           ; [in/out] 0.1   , 2.0   , 0.83   , high-frequency to mid-frequency decay time ratio (win32/xbox) 
  DecayLFRatio.f           ; [in/out] 0.1   , 2.0   , 1.0    , low-frequency to mid-frequency decay time ratio (win32 only) 
  Reflections.l              ; [in/out] -10000, 1000  , -2602  , early reflections level relative to room effect (win32/xbox) 
  ReflectionsDelay.f       ; [in/out] 0.0   , 0.3   , 0.007  , initial reflection delay time (win32/xbox) 
  ReflectionsPan.f[3]      ; [in/out]       ,       , [0,0,0], early reflections panning vector (win32 only) 
  Reverb.l                   ; [in/out] -10000, 2000  , 200    , late reverberation level relative to room effect (win32/xbox) 
  ReverbDelay.f            ; [in/out] 0.0   , 0.1   , 0.011  , late reverberation delay time relative to initial reflection (win32/xbox) 
  ReverbPan.f[3]           ; [in/out]       ,       , [0,0,0], late reverberation panning vector (win32 only) 
  EchoTime.f               ; [in/out] .075  , 0.25  , 0.25   , echo time (win32 only) 
  EchoDepth.f              ; [in/out] 0.0   , 1.0   , 0.0    , echo depth (win32 only) 
  ModulationTime.f         ; [in/out] 0.04  , 4.0   , 0.25   , modulation time (win32 only) 
  ModulationDepth.f        ; [in/out] 0.0   , 1.0   , 0.0    , modulation depth (win32 only) 
  AirAbsorptionHF.f        ; [in/out] -100  , 0.0   , -5.0   , change in level per meter at high frequencies (win32 only) 
  HFReference.f            ; [in/out] 1000.0, 20000 , 5000.0 , reference high frequency (hz) (win32/xbox) 
  LFReference.f            ; [in/out] 20.0  , 1000.0, 250.0  , reference low frequency (hz) (win32 only) 
  RoomRolloffFactor.f      ; [in/out] 0.0   , 10.0  , 0.0    , like FMOD_3D_Listener_SetRolloffFactor but for room effect (win32/xbox) 
  Diffusion.f              ; [in/out] 0.0   , 100.0 , 100.0  , Value that controls the echo density in the late reverberation decay. (xbox only) 
  Density.f                ; [in/out] 0.0   , 100.0 , 100.0  , Value that controls the modal density in the late reverberation decay (xbox only) 
  flags.l                    ; [in/out] FMOD_REVERB_FLAGS - modifies the behavior of above properties (win32/ps2) 
EndStructure

#FMOD_REVERB_FLAGS_DECAYTIMESCALE         = $1               ; 'EnvSize' affects reverberation decay time 
#FMOD_REVERB_FLAGS_REFLECTIONSSCALE       = $2             ; 'EnvSize' affects reflection level 
#FMOD_REVERB_FLAGS_REFLECTIONSDELAYSCALE  = $4        ; 'EnvSize' affects initial reflection delay time 
#FMOD_REVERB_FLAGS_REVERBSCALE            = $8        ; 'EnvSize' affects reflections level 
#FMOD_REVERB_FLAGS_REVERBDELAYSCALE       = $10       ; 'EnvSize' affects late reverberation delay time 
#FMOD_REVERB_FLAGS_DECAYHFLIMIT           = $20       ; AirAbsorptionHF affects DecayHFRatio 
#FMOD_REVERB_FLAGS_ECHOTIMESCALE          = $40       ; 'EnvSize' affects echo time 
#FMOD_REVERB_FLAGS_MODULATIONTIMESCALE    = $80       ; 'EnvSize' affects modulation time 
#FMOD_REVERB_FLAGS_DEFAULT                = (#FMOD_REVERB_FLAGS_DECAYTIMESCALE | #FMOD_REVERB_FLAGS_REFLECTIONSSCALE | #FMOD_REVERB_FLAGS_REFLECTIONSDELAYSCALE | #FMOD_REVERB_FLAGS_REVERBSCALE | #FMOD_REVERB_FLAGS_REVERBDELAYSCALE | #FMOD_REVERB_FLAGS_DECAYHFLIMIT)

Structure FMOD_REVERB_CHANNELPROPERTIES
  Direct.l                   ; [in/out] -10000, 1000,  0,       direct path level (at low and mid frequencies) (win32/xbox) 
  DirectHF.l                 ; [in/out] -10000, 0,     0,       relative direct path level at high frequencies (win32/xbox) 
  Room.l                     ; [in/out] -10000, 1000,  0,       room effect level (at low and mid frequencies) (win32/xbox) 
  RoomHF.l                   ; [in/out] -10000, 0,     0,       relative room effect level at high frequencies (win32/xbox) 
  Obstruction.l              ; [in/out] -10000, 0,     0,       main obstruction control (attenuation at high frequencies)  (win32/xbox) 
  ObstructionLFRatio.f     ; [in/out] 0.0,    1.0,   0.0,     obstruction low-frequency level re. main control (win32/xbox) 
  Occlusion.l                ; [in/out] -10000, 0,     0,       main occlusion control (attenuation at high frequencies) (win32/xbox) 
  OcclusionLFRatio.f       ; [in/out] 0.0,    1.0,   0.25,    occlusion low-frequency level re. main control (win32/xbox) 
  OcclusionRoomRatio.f     ; [in/out] 0.0,    10.0,  1.5,     relative occlusion control for room effect (win32) 
  OcclusionDirectRatio.f   ; [in/out] 0.0,    10.0,  1.0,     relative occlusion control for direct path (win32) 
  Exclusion.l                ; [in/out] -10000, 0,     0,       main exlusion control (attenuation at high frequencies) (win32) 
  ExclusionLFRatio.f       ; [in/out] 0.0,    1.0,   1.0,     exclusion low-frequency level re. main control (win32) 
  OutsideVolumeHF.l          ; [in/out] -10000, 0,     0,       outside sound cone level at high frequencies (win32) 
  DopplerFactor.f          ; [in/out] 0.0,    10.0,  0.0,     like DS3D flDopplerFactor but per source (win32) 
  RolloffFactor.f          ; [in/out] 0.0,    10.0,  0.0,     like DS3D flRolloffFactor but per source (win32) 
  RoomRolloffFactor.f      ; [in/out] 0.0,    10.0,  0.0,     like DS3D flRolloffFactor but for room effect (win32/xbox) 
  AirAbsorptionFactor.f    ; [in/out] 0.0,    10.0,  1.0,     multiplies AirAbsorptionHF member of FMOD_REVERB_PROPERTIES (win32) 
  flags.l                    ; [in/out] FMOD_REVERB_CHANNELFLAGS - modifies the behavior of properties (win32) 
EndStructure

Structure FMOD_DSP_DESCRIPTION
  name.b[32]                 ; [in] Name of the unit to be displayed in the network.
  Version.l                  ; [in] Plugin writer's version number.
  Channels.l                 ; [in] Number of channels.  Use 0 to process whatever number of channels is currently in the network.  >0 would be mostly used if the unit is a fixed format generator and not a filter.
  create.l                   ; [in] Create callback.  This is called when DSP unit is created.  Can be null.
  release.l                  ; [in] Release callback.  This is called just before the unit is freed so the user can do any cleanup needed for the unit.  Can be null.
  reset.l                    ; [in] Reset callback.  This is called by the user to reset any history buffers that may need resetting for a filter, when it is to be used or re-used for the first time to its initial clean state.  Use to avoid clicks or artifacts.
  Read.l                     ; [in] Read callback.  Processing is done here.  Can be null.
  setpos.l                   ; [in] Setposition callback.  This is called if the unit becomes virtualized and needs to simply update positions etc.  Can be null.
  
  numparameters.l            ; [in] Number of parameters used in this filter.  The user finds this with DSP::getNumParameters 
  paramdesc.l                ; [in] Variable number of parameter structures.
  setparameter.l             ; [in] This is called when the user calls DSP::setParameter.  Can be null.
  getparameter.l             ; [in] This is called when the user calls DSP::getParameter.  Can be null.
  config.l                   ; [in] This is called when the user calls DSP::showConfigDialog.  Can be used to display a dialog to configure the filter.  Can be null.
  Configwidth.l              ; [in] Width of config dialog graphic if there is one.  0 otherwise.
  Configheight.l             ; [in] Height of config dialog graphic if there is one.  0 otherwise.
  userdata.l                 ; [in] Optional. Specify 0 to ignore. This is user data to be attached to the DSP unit during creation.  Access via DSP::getUserData.
EndStructure

#FMOD_REVERB_CHANNELFLAGS_DIRECTHFAUTO  = $1        ; Automatic setting of 'Direct'  due to distance from listener 
#FMOD_REVERB_CHANNELFLAGS_ROOMAUTO      = $2        ; Automatic setting of 'Room'  due to distance from listener 
#FMOD_REVERB_CHANNELFLAGS_ROOMHFAUTO    = $4        ; Automatic setting of 'RoomHF' due to distance from listener 
#FMOD_REVERB_CHANNELFLAGS_ENVIRONMENT0  = $8        ; EAX4 only. Specify channel to target reverb instance 0.
#FMOD_REVERB_CHANNELFLAGS_ENVIRONMENT1  = $10       ; EAX4 only. Specify channel to target reverb instance 1.
#FMOD_REVERB_CHANNELFLAGS_ENVIRONMENT2  = $20       ; EAX4 only. Specify channel to target reverb instance 2.

#FMOD_REVERB_CHANNELFLAGS_DEFAULT       = (#FMOD_REVERB_CHANNELFLAGS_DIRECTHFAUTO | #FMOD_REVERB_CHANNELFLAGS_ROOMAUTO | #FMOD_REVERB_CHANNELFLAGS_ROOMHFAUTO | #FMOD_REVERB_CHANNELFLAGS_ENVIRONMENT0)

Structure FMOD_ADVANCEDSETTINGS
  cbSize.l          ; Size of structure.  Use sizeof(FMOD_ADVANCEDSETTINGS)
  maxMPEGcodecs.l   ; For use with FMOD_CREATECOMPRESSEDSAMPLE only.  Mpeg  codecs consume 48,696 per instance and this number will determine how many mpeg channels can be played simultaneously.  Default = 16.
  maxADPCMcodecs.l  ; For use with FMOD_CREATECOMPRESSEDSAMPLE only.  ADPCM codecs consume 1k per instance and this number will determine how many ADPCM channels can be played simultaneously.  Default = 32.
  maxXMAcodecs.l    ; For use with FMOD_CREATECOMPRESSEDSAMPLE only.  XMA   codecs consume 8k per instance and this number will determine how many XMA channels can be played simultaneously.  Default = 32.
EndStructure

Enumeration ; FMOD_CHANNELINDEX
  #FMOD_CHANNEL_FREE = -1     ; For a channel index, FMOD chooses a free voice using the priority system.
  #FMOD_CHANNEL_REUSE = -2    ; For a channel index, re-use the channel handle that was passed in.
EndEnumeration

;- ### Main part
Global fmodLib = OpenLibrary(#PB_Any, "DLL\fmodex.dll")

   ;- FMOD_Memory_Initialize
   Prototype.l FMOD_Memory_Initialize_Prototype(poolmem.l, poollen.l, useralloc.l, userrealloc.l, userfree.l)
   Global FMOD_Memory_Initialize.FMod_Memory_Initialize_Prototype
   FMOD_Memory_Initialize = GetFunction(fmodLib, "FMOD_Memory_Initialize")
   
   Prototype.l FMOD_Memory_GetStats_Prototype(*currentalloced.Long, *maxalloced.Long)
   Global FMOD_Memory_GetStats.FMod_Memory_GetStats_Prototype
   FMOD_Memory_GetStats= GetFunction(fmodLib, "FMOD_Memory_GetStats")
   
   ;- FMOD_Debug_SetLevel
   Prototype.l FMOD_Debug_SetLevel_Prototype(level.l)
   Global FMOD_Debug_SetLevel.FMod_Debug_SetLevel_Prototype
   FMOD_Debug_SetLevel = GetFunction(fmodLib, "FMOD_Debug_SetLevel")
   
   ;- FMOD_Debug_GetLevel
   Prototype.l FMOD_Debug_GetLevel_Prototype(*level.Long)
   Global FMOD_Debug_GetLevel.FMod_Debug_GetLevel_Prototype
   FMOD_Debug_GetLevel = GetFunction(fmodLib, "FMOD_Debug_GetLevel")
   
   ;- FMOD_File_SetDiskBusy
   Prototype.l FMOD_File_SetDiskBusy_Prototype(busy.l)
   Global FMOD_File_SetDiskBusy.FMod_File_SetDiskBusy_Prototype
   FMOD_File_SetDiskBusy = GetFunction(fmodLib, "FMOD_File_SetDiskBusy")
   
   ;- FMOD_File_GetDiskBusy
   Prototype.l FMOD_File_GetDiskBusy_Prototype(*busy.Long)
   Global FMOD_File_GetDiskBusy.FMod_File_GetDiskBusy_Prototype
   FMOD_File_GetDiskBusy = GetFunction(fmodLib, "FMOD_File_GetDiskBusy")
   
   ;- FMOD_System_Create
   Prototype.l FMOD_System_Create_Prototype(*system.Long)
   Global FMOD_System_Create.FMod_System_Create_Prototype
   FMOD_System_Create = GetFunction(fmodLib, "FMOD_System_Create")
   
   ;- FMOD_System_Release
   Prototype.l FMOD_System_Release_Prototype(system.l)
   Global FMOD_System_Release.FMod_System_Release_Prototype
   FMOD_System_Release = GetFunction(fmodLib, "FMOD_System_Release")
   
   ;- FMOD_System_SetOutput
   Prototype.l FMOD_System_SetOutput_Prototype(system.l, Output.l)
   Global FMOD_System_SetOutput.FMod_System_SetOutput_Prototype
   FMOD_System_SetOutput = GetFunction(fmodLib, "FMOD_System_SetOutput")
   
   ;- FMOD_System_GetOutput
   Prototype.l FMOD_System_GetOutput_Prototype(system.l, *Output.Long)
   Global FMOD_System_GetOutput.FMod_System_GetOutput_Prototype
   FMOD_System_GetOutput = GetFunction(fmodLib, "FMOD_System_GetOutput")
   
   ;- FMOD_System_GetNumDrivers
   Prototype.l FMOD_System_GetNumDrivers_Prototype(system.l, *Numdrivers.Long)
   Global FMOD_System_GetNumDrivers.FMod_System_GetNumDrivers_Prototype
   FMOD_System_GetNumDrivers = GetFunction(fmodLib, "FMOD_System_GetNumDrivers")
   
   ;- FMOD_System_GetDriverName
   Prototype.l FMOD_System_GetDriverName_Prototype(system.l, id.l, *name.Byte, Namelen.l)
   Global FMOD_System_GetDriverName.FMod_System_GetDriverName_Prototype
   FMOD_System_GetDriverName = GetFunction(fmodLib, "FMOD_System_GetDriverName")
   
   ;- FMOD_System_GetDriverCaps
   Prototype.l FMOD_System_GetDriverCaps_Prototype(system.l, id.l, *caps.Long, *minfrequency.Long, *maxfrequency.Long, *controlpanelspeakermode.Long)
   Global FMOD_System_GetDriverCaps.FMod_System_GetDriverCaps_Prototype
   FMOD_System_GetDriverCaps = GetFunction(fmodLib, "FMOD_System_GetDriverCaps")
   
   ;- FMOD_System_SetDriver_
   Prototype.l FMOD_System_SetDriver_Prototype (system.l, Driver.l)
   Global FMOD_System_SetDriver.FMod_System_SetDriver_Prototype
   FMOD_System_SetDriver = GetFunction(fmodLib, "FMOD_System_SetDriver")
   
   ;- FMOD_System_GetDriver_
   Prototype.l FMOD_System_GetDriver_Prototype (system.l, *Driver.Long)
   Global FMOD_System_GetDriver.FMod_System_GetDriver_Prototype
   FMOD_System_GetDriver = GetFunction(fmodLib, "FMOD_System_GetDriver")
   
   ;- FMOD_System_SetHardwareChannels_
   Prototype.l FMOD_System_SetHardwareChannels_Prototype (system.l, Min2d.l, Max2d.l, Min3d.l, Max3d.l)
   Global FMOD_System_SetHardwareChannels.FMod_System_SetHardwareChannels_Prototype
   FMOD_System_SetHardwareChannels = GetFunction(fmodLib, "FMOD_System_SetHardwareChannels")
   
   ;- FMOD_System_GetHardwareChannels_
   Prototype.l FMOD_System_GetHardwareChannels_Prototype (system.l, *Num2d.Long, *Num3d.Long, *total.Long)
   Global FMOD_System_GetHardwareChannels.FMod_System_GetHardwareChannels_Prototype
   FMOD_System_GetHardwareChannels = GetFunction(fmodLib, "FMOD_System_GetHardwareChannels")
   
   ;- FMOD_System_SetSoftwareChannels_
   Prototype.l FMOD_System_SetSoftwareChannels_Prototype (system.l, Numsoftwarechannels.l)
   Global FMOD_System_SetSoftwareChannels.FMod_System_SetSoftwareChannels_Prototype
   FMOD_System_SetSoftwareChannels = GetFunction(fmodLib, "FMOD_System_SetSoftwareChannels")
   
   ;- FMOD_System_GetSoftwareChannels_
   Prototype.l FMOD_System_GetSoftwareChannels_Prototype (system.l, *Numsoftwarechannels.Long)
   Global FMOD_System_GetSoftwareChannels.FMod_System_GetSoftwareChannels_Prototype
   FMOD_System_GetSoftwareChannels = GetFunction(fmodLib, "FMOD_System_GetSoftwareChannels")
   
   ;- FMOD_System_SetSoftwareFormat_
   Prototype.l FMOD_System_SetSoftwareFormat_Prototype (system.l, Samplerate.l, Format.l, Numoutputchannels.l, Maxinputchannels.l, Resamplemethod.l)
   Global FMOD_System_SetSoftwareFormat.FMod_System_SetSoftwareFormat_Prototype
   FMOD_System_SetSoftwareFormat = GetFunction(fmodLib, "FMOD_System_SetSoftwareFormat")
   
   ;- FMOD_System_GetSoftwareFormat_
   Prototype.l FMOD_System_GetSoftwareFormat_Prototype (system.l, *Samplerate.Long, *Format.Long, *Numoutputchannels.Long, *Maxinputchannels.Long, *Resamplemethod.Long, *Bits.Long)
   Global FMOD_System_GetSoftwareFormat.FMod_System_GetSoftwareFormat_Prototype
   FMOD_System_GetSoftwareFormat = GetFunction(fmodLib, "FMOD_System_GetSoftwareFormat")
   
   ;- FMOD_System_SetDSPBufferSize_
   Prototype.l FMOD_System_SetDSPBufferSize_Prototype (system.l, Bufferlength.l, Numbuffers.l)
   Global FMOD_System_SetDSPBufferSize.FMod_System_SetDSPBufferSize_Prototype
   FMOD_System_SetDSPBufferSize = GetFunction(fmodLib, "FMOD_System_SetDSPBufferSize")
   
   ;- FMOD_System_GetDSPBufferSize_
   Prototype.l FMOD_System_GetDSPBufferSize_Prototype (system.l, *Bufferlength.Long, *Numbuffers.Long)
   Global FMOD_System_GetDSPBufferSize.FMod_System_GetDSPBufferSize_Prototype
   FMOD_System_GetDSPBufferSize = GetFunction(fmodLib, "FMOD_System_GetDSPBufferSize")
   
   ;- FMOD_System_SetFileSystem_
   Prototype.l FMOD_System_SetFileSystem_Prototype (system.l, useropen.l, userclose.l, userread.l, userseek.l, Buffersize.l)
   Global FMOD_System_SetFileSystem.FMod_System_SetFileSystem_Prototype
   FMOD_System_SetFileSystem = GetFunction(fmodLib, "FMOD_System_SetFileSystem")
   
   ;- FMOD_System_AttachFileSystem_
   Prototype.l FMOD_System_AttachFileSystem_Prototype (system.l, useropen.l, userclose.l, userread.l, userseek.l)
   Global FMOD_System_AttachFileSystem.FMod_System_AttachFileSystem_Prototype
   FMOD_System_AttachFileSystem = GetFunction(fmodLib, "FMOD_System_AttachFileSystem")
   
   ;- FMOD_System_SetAdvancedSettings_
   Prototype.l FMOD_System_SetAdvancedSettings_Prototype (system.l, *settings.Long)
   Global FMOD_System_SetAdvancedSettings.FMod_System_SetAdvancedSettings_Prototype
   FMOD_System_SetAdvancedSettings = GetFunction(fmodLib, "FMOD_System_SetAdvancedSettings")
   
   ;- FMOD_System_GetAdvancedSettings_
   Prototype.l FMOD_System_GetAdvancedSettings_Prototype (system.l, *settings.Long)
   Global FMOD_System_GetAdvancedSettings.FMod_System_GetAdvancedSettings_Prototype
   FMOD_System_GetAdvancedSettings = GetFunction(fmodLib, "FMOD_System_GetAdvancedSettings")
   
   ;- FMOD_System_SetSpeakerMode_
   Prototype.l FMOD_System_SetSpeakerMode_Prototype (system.l, Speakermode.l)
   Global FMOD_System_SetSpeakerMode.FMod_System_SetSpeakerMode_Prototype
   FMOD_System_SetSpeakerMode = GetFunction(fmodLib, "FMOD_System_SetSpeakerMode")
   
   ;- FMOD_System_GetSpeakerMode_
   Prototype.l FMOD_System_GetSpeakerMode_Prototype (system.l, *Speakermode.long)
   Global FMOD_System_GetSpeakerMode.FMod_System_GetSpeakerMode_Prototype
   FMOD_System_GetSpeakerMode = GetFunction(fmodLib, "FMOD_System_GetSpeakerMode")
   
   ;- FMOD_System_SetPluginPath_
   Prototype.l FMOD_System_SetPluginPath_Prototype (system.l, Path.s)
   Global FMOD_System_SetPluginPath.FMod_System_SetPluginPath_Prototype
   FMOD_System_SetPluginPath = GetFunction(fmodLib, "FMOD_System_SetPluginPath")
   
   ;- FMOD_System_LoadPlugin_
   Prototype.l FMOD_System_LoadPlugin_Prototype (system.l, Filename.s, *Plugintype.Long, *Index.Long)
   Global FMOD_System_LoadPlugin.FMod_System_LoadPlugin_Prototype
   FMOD_System_LoadPlugin = GetFunction(fmodLib, "FMOD_System_LoadPlugin")
   
   ;- FMOD_System_GetNumPlugins_
   Prototype.l FMOD_System_GetNumPlugins_Prototype (system.l, Plugintype.l, *Numplugins.Long)
   Global FMOD_System_GetNumPlugins.FMod_System_GetNumPlugins_Prototype
   FMOD_System_GetNumPlugins = GetFunction(fmodLib, "FMOD_System_GetNumPlugins")
   
   ;- FMOD_System_GetPluginInfo_
   Prototype.l FMOD_System_GetPluginInfo_Prototype (system.l, Plugintype.l, Index.l, *name.Byte, Namelen.l, *version.Long)
   Global FMOD_System_GetPluginInfo.FMod_System_GetPluginInfo_Prototype
   FMOD_System_GetPluginInfo = GetFunction(fmodLib, "FMOD_System_GetPluginInfo")
   
   ;- FMOD_System_UnloadPlugin_
   Prototype.l FMOD_System_UnloadPlugin_Prototype (system.l, Plugintype.l, *Index.Long)
   Global FMOD_System_UnloadPlugin.FMod_System_UnloadPlugin_Prototype
   FMOD_System_UnloadPlugin = GetFunction(fmodLib, "FMOD_System_UnloadPlugin")
   
   ;- FMOD_System_SetOutputByPlugin_
   Prototype.l FMOD_System_SetOutputByPlugin_Prototype (system.l, Index.l)
   Global FMOD_System_SetOutputByPlugin.FMod_System_SetOutputByPlugin_Prototype
   FMOD_System_SetOutputByPlugin = GetFunction(fmodLib, "FMOD_System_SetOutputByPlugin")
   
   ;- FMOD_System_GetOutputByPlugin_
   Prototype.l FMOD_System_GetOutputByPlugin_Prototype (system.l, *Index.Long)
   Global FMOD_System_GetOutputByPlugin.FMod_System_GetOutputByPlugin_Prototype
   FMOD_System_GetOutputByPlugin = GetFunction(fmodLib, "FMOD_System_GetOutputByPlugin")
   
   ;- FMOD_System_CreateCodec_
   Prototype.l FMOD_System_CreateCodec_Prototype (system.l, CodecDescription.l)
   Global FMOD_System_CreateCodec.FMod_System_CreateCodec_Prototype
   FMOD_System_CreateCodec = GetFunction(fmodLib, "FMOD_System_CreateCodec")
   
   ;- FMOD_System_Init_
   Prototype.l FMOD_System_Init_Prototype (system.l, Maxchannels.l, flags.l, Extradriverdata.l)
   Global FMOD_System_Init.FMod_System_Init_Prototype
   FMOD_System_Init = GetFunction(fmodLib, "FMOD_System_Init")
   
   ;- FMOD_System_Close_
   Prototype.l FMOD_System_Close_Prototype (system.l)
   Global FMOD_System_Close.FMod_System_Close_Prototype
   FMOD_System_Close = GetFunction(fmodLib, "FMOD_System_Close")
   
   ;- FMOD_System_Update_
   Prototype.l FMOD_System_Update_Prototype (system.l)
   Global FMOD_System_Update.FMod_System_Update_Prototype
   FMOD_System_Update = GetFunction(fmodLib, "FMOD_System_Update")
   
   ;- FMOD_System_UpdateFinished_
   Prototype.l FMOD_System_UpdateFinished_Prototype (system.l)
   Global FMOD_System_UpdateFinished.FMod_System_UpdateFinished_Prototype
   FMOD_System_UpdateFinished = GetFunction(fmodLib, "FMOD_System_UpdateFinished")
   
   ;- FMOD_System_Set3DSettings_
   Prototype.l FMOD_System_Set3DSettings_Prototype (system.l, Dopplerscale.f, Distancefactor.f, Rolloffscale.f)
   Global FMOD_System_Set3DSettings.FMod_System_Set3DSettings_Prototype
   FMOD_System_Set3DSettings = GetFunction(fmodLib, "FMOD_System_Set3DSettings")
   
   ;- FMOD_System_Get3DSettings_
   Prototype.l FMOD_System_Get3DSettings_Prototype (system.l, *Dopplerscale.Float, *Distancefactor.Float, *Rolloffscale.Float)
   Global FMOD_System_Get3DSettings.FMod_System_Get3DSettings_Prototype
   FMOD_System_Get3DSettings = GetFunction(fmodLib, "FMOD_System_Get3DSettings")
   
   ;- FMOD_System_Set3DNumListeners_
   Prototype.l FMOD_System_Set3DNumListeners_Prototype (system.l, Numlisteners.l)
   Global FMOD_System_Set3DNumListeners.FMod_System_Set3DNumListeners_Prototype
   FMOD_System_Set3DNumListeners = GetFunction(fmodLib, "FMOD_System_Set3DNumListeners")
   
   ;- FMOD_System_Get3DNumListeners_
   Prototype.l FMOD_System_Get3DNumListeners_Prototype (system.l, *Numlisteners.Long)
   Global FMOD_System_Get3DNumListeners.FMod_System_Get3DNumListeners_Prototype
   FMOD_System_Get3DNumListeners = GetFunction(fmodLib, "FMOD_System_Get3DNumListeners")
   
   ;- FMOD_System_Set3DListenerAttributes_
   Prototype.l FMOD_System_Set3DListenerAttributes_Prototype (system.l, Listener.l, *Pos.Long, *Vel.Long, *Forward.Long, *Up.Long)
   Global FMOD_System_Set3DListenerAttributes.FMod_System_Set3DListenerAttributes_Prototype
   FMOD_System_Set3DListenerAttributes = GetFunction(fmodLib, "FMOD_System_Set3DListenerAttributes")
   
   ;- FMOD_System_Get3DListenerAttributes_
   Prototype.l FMOD_System_Get3DListenerAttributes_Prototype (system.l, Listener.l, *Pos.Long, *Vel.Long, *Forward.Long, *Up.Long)
   Global FMOD_System_Get3DListenerAttributes.FMod_System_Get3DListenerAttributes_Prototype
   FMOD_System_Get3DListenerAttributes = GetFunction(fmodLib, "FMOD_System_Get3DListenerAttributes")
   
   ;- FMOD_System_SetSpeakerPosition_
   Prototype.l FMOD_System_SetSpeakerPosition_Prototype (system.l, Speaker.l, x.f, y.f)
   Global FMOD_System_SetSpeakerPosition.FMod_System_SetSpeakerPosition_Prototype
   FMOD_System_SetSpeakerPosition = GetFunction(fmodLib, "FMOD_System_SetSpeakerPosition")
   
   ;- FMOD_System_GetSpeakerPosition_
   Prototype.l FMOD_System_GetSpeakerPosition_Prototype (system.l, *Speaker.Long, *X.Float, *Y.Float)
   Global FMOD_System_GetSpeakerPosition.FMod_System_GetSpeakerPosition_Prototype
   FMOD_System_GetSpeakerPosition = GetFunction(fmodLib, "FMOD_System_GetSpeakerPosition")
   
   ;- FMOD_System_SetStreamBufferSize_
   Prototype.l FMOD_System_SetStreamBufferSize_Prototype (system.l, Filebuffersize.l, Filebuffersizetype.l)
   Global FMOD_System_SetStreamBufferSize.FMod_System_SetStreamBufferSize_Prototype
   FMOD_System_SetStreamBufferSize = GetFunction(fmodLib, "FMOD_System_SetStreamBufferSize")
   
   ;- FMOD_System_GetStreamBufferSize_
   Prototype.l FMOD_System_GetStreamBufferSize_Prototype (system.l, *Filebuffersize.Long, *Filebuffersizetype.Long)
   Global FMOD_System_GetStreamBufferSize.FMod_System_GetStreamBufferSize_Prototype
   FMOD_System_GetStreamBufferSize = GetFunction(fmodLib, "FMOD_System_GetStreamBufferSize")
   
   ;- FMOD_System_GetVersion_
   Prototype.l FMOD_System_GetVersion_Prototype (system.l, *version.Long)
   Global FMOD_System_GetVersion.FMod_System_GetVersion_Prototype
   FMOD_System_GetVersion = GetFunction(fmodLib, "FMOD_System_GetVersion")
   
   ;- FMOD_System_GetOutputHandle_
   Prototype.l FMOD_System_GetOutputHandle_Prototype (system.l, *Handle.Long)
   Global FMOD_System_GetOutputHandle.FMod_System_GetOutputHandle_Prototype
   FMOD_System_GetOutputHandle = GetFunction(fmodLib, "FMOD_System_GetOutputHandle")
   
   ;- FMOD_System_GetChannelsPlaying_
   Prototype.l FMOD_System_GetChannelsPlaying_Prototype (system.l, *Channels.Long)
   Global FMOD_System_GetChannelsPlaying.FMod_System_GetChannelsPlaying_Prototype
   FMOD_System_GetChannelsPlaying = GetFunction(fmodLib, "FMOD_System_GetChannelsPlaying")
   
   ;- FMOD_System_GetCPUUsage_
   Prototype.l FMOD_System_GetCPUUsage_Prototype (system.l, *Dsp.Float, *Stream.Float, *Update.Float, *total.Float)
   Global FMOD_System_GetCPUUsage.FMod_System_GetCPUUsage_Prototype
   FMOD_System_GetCPUUsage = GetFunction(fmodLib, "FMOD_System_GetCPUUsage")
   
   ;- FMOD_System_GetSoundRAM_
   Prototype.l FMOD_System_GetSoundRAM_Prototype (system.l, *currentalloced.Long, *maxalloced.Long, *total.Long)
   Global FMOD_System_GetSoundRAM.FMod_System_GetSoundRAM_Prototype
   FMOD_System_GetSoundRAM = GetFunction(fmodLib, "FMOD_System_GetSoundRAM")
   
   ;- FMOD_System_GetNumCDROMDrives_
   Prototype.l FMOD_System_GetNumCDROMDrives_Prototype (system.l, *Numdrives.Long)
   Global FMOD_System_GetNumCDROMDrives.FMod_System_GetNumCDROMDrives_Prototype
   FMOD_System_GetNumCDROMDrives = GetFunction(fmodLib, "FMOD_System_GetNumCDROMDrives")
   
   ;- FMOD_System_GetCDROMDriveName_
   Prototype.l FMOD_System_GetCDROMDriveName_Prototype (system.l, Drive.l, *Drivename.Byte, Drivenamelen.l, *Scsiname.Byte, Scsinamelen.l, *Devicename.Byte, Devicenamelen.l)
   Global FMOD_System_GetCDROMDriveName.FMod_System_GetCDROMDriveName_Prototype
   FMOD_System_GetCDROMDriveName = GetFunction(fmodLib, "FMOD_System_GetCDROMDriveName")
   
   ;- FMOD_System_GetSpectrum_
   Prototype.l FMOD_System_GetSpectrum_Prototype (system.l, *Spectrumarray.Float, Numvalues.l, Channeloffset.l, *Windowtype.Long)
   Global FMOD_System_GetSpectrum.FMod_System_GetSpectrum_Prototype
   FMOD_System_GetSpectrum = GetFunction(fmodLib, "FMOD_System_GetSpectrum")
   
   ;- FMOD_System_GetWaveData_
   Prototype.l FMOD_System_GetWaveData_Prototype (system.l, *Wavearray.Float, Numvalues.l, Channeloffset.l)
   Global FMOD_System_GetWaveData.FMod_System_GetWaveData_Prototype
   FMOD_System_GetWaveData = GetFunction(fmodLib, "FMOD_System_GetWaveData")
   
   ;- FMOD_System_CreateSound_
   Prototype.l FMOD_System_CreateSound_Prototype (system.l, Name_or_data.l, Mode.l, *exinfo.Long, *Sound.Long)
   Global FMOD_System_CreateSound.FMod_System_CreateSound_Prototype
   FMOD_System_CreateSound = GetFunction(fmodLib, "FMOD_System_CreateSound")
   
   ;- FMOD_System_CreateStream_
   Prototype.l FMOD_System_CreateStream_Prototype (system.l, Name_or_data.l, Mode.l, *exinfo.Long, *Sound.Long)
   Global FMOD_System_CreateStream.FMod_System_CreateStream_Prototype
   FMOD_System_CreateStream = GetFunction(fmodLib, "FMOD_System_CreateStream")
   
   ;- FMOD_System_CreateDSP_
   Prototype.l FMOD_System_CreateDSP_Prototype (system.l, *description.Long, *Dsp.Long)
   Global FMOD_System_CreateDSP.FMod_System_CreateDSP_Prototype
   FMOD_System_CreateDSP = GetFunction(fmodLib, "FMOD_System_CreateDSP")
   
   ;- FMOD_System_CreateDSPByType_
   Prototype.l FMOD_System_CreateDSPByType_Prototype (system.l, dsptype.l, *Dsp.Long)
   Global FMOD_System_CreateDSPByType.FMod_System_CreateDSPByType_Prototype
   FMOD_System_CreateDSPByType = GetFunction(fmodLib, "FMOD_System_CreateDSPByType")
   
   ;- FMOD_System_CreateDSPByIndex_
   Prototype.l FMOD_System_CreateDSPByIndex_Prototype (system.l, Index.l, *Dsp.Long)
   Global FMOD_System_CreateDSPByIndex.FMod_System_CreateDSPByIndex_Prototype
   FMOD_System_CreateDSPByIndex = GetFunction(fmodLib, "FMOD_System_CreateDSPByIndex")
   
   ;- FMOD_System_CreateChannelGroup_
   Prototype.l FMOD_System_CreateChannelGroup_Prototype (system.l, name.s, *Channelgroup.Long)
   Global FMOD_System_CreateChannelGroup.FMod_System_CreateChannelGroup_Prototype
   FMOD_System_CreateChannelGroup = GetFunction(fmodLib, "FMOD_System_CreateChannelGroup")
   
   ;- FMOD_System_PlaySound_
   Prototype.l FMOD_System_PlaySound_Prototype (system.l, channelid.l, sound.l, paused.l, *channel.Long)
   Global FMOD_System_PlaySound.FMod_System_PlaySound_Prototype
   FMOD_System_PlaySound = GetFunction(fmodLib, "FMOD_System_PlaySound")
   
   ;- FMOD_System_PlayDSP_
   Prototype.l FMOD_System_PlayDSP_Prototype (system.l, channelid.l, Dsp.l, paused.l, *channel.Long)
   Global FMOD_System_PlayDSP.FMod_System_PlayDSP_Prototype
   FMOD_System_PlayDSP = GetFunction(fmodLib, "FMOD_System_PlayDSP")
   
   ;- FMOD_System_GetChannel_
   Prototype.l FMOD_System_GetChannel_Prototype (system.l, channelid.l, *channel.Long)
   Global FMOD_System_GetChannel.FMod_System_GetChannel_Prototype
   FMOD_System_GetChannel = GetFunction(fmodLib, "FMOD_System_GetChannel")
   
   ;- FMOD_System_GetMasterChannelGroup_
   Prototype.l FMOD_System_GetMasterChannelGroup_Prototype (system.l, *Channelgroup.Long)
   Global FMOD_System_GetMasterChannelGroup.FMod_System_GetMasterChannelGroup_Prototype
   FMOD_System_GetMasterChannelGroup = GetFunction(fmodLib, "FMOD_System_GetMasterChannelGroup")
   
   ;- FMOD_System_SetReverbProperties_
   Prototype.l FMOD_System_SetReverbProperties_Prototype (system.l, *Prop.Long)
   Global FMOD_System_SetReverbProperties.FMod_System_SetReverbProperties_Prototype
   FMOD_System_SetReverbProperties = GetFunction(fmodLib, "FMOD_System_SetReverbProperties")
   
   ;- FMOD_System_GetReverbProperties_
   Prototype.l FMOD_System_GetReverbProperties_Prototype (system.l, *Prop.Long)
   Global FMOD_System_GetReverbProperties.FMod_System_GetReverbProperties_Prototype
   FMOD_System_GetReverbProperties = GetFunction(fmodLib, "FMOD_System_GetReverbProperties")
   
   ;- FMOD_System_GetDSPHead_
   Prototype.l FMOD_System_GetDSPHead_Prototype (system.l, *Dsp.Long)
   Global FMOD_System_GetDSPHead.FMod_System_GetDSPHead_Prototype
   FMOD_System_GetDSPHead = GetFunction(fmodLib, "FMOD_System_GetDSPHead")
   
   ;- FMOD_System_AddDSP_
   Prototype.l FMOD_System_AddDSP_Prototype (system.l, Dsp.l)
   Global FMOD_System_AddDSP.FMod_System_AddDSP_Prototype
   FMOD_System_AddDSP = GetFunction(fmodLib, "FMOD_System_AddDSP")
   
   ;- FMOD_System_LockDSP_
   Prototype.l FMOD_System_LockDSP_Prototype (system.l)
   Global FMOD_System_LockDSP.FMod_System_LockDSP_Prototype
   FMOD_System_LockDSP = GetFunction(fmodLib, "FMOD_System_LockDSP")
   
   ;- FMOD_System_UnlockDSP_
   Prototype.l FMOD_System_UnlockDSP_Prototype (system.l)
   Global FMOD_System_UnlockDSP.FMod_System_UnlockDSP_Prototype
   FMOD_System_UnlockDSP = GetFunction(fmodLib, "FMOD_System_UnlockDSP")
   
   ;- FMOD_System_SetRecordDriver_
   Prototype.l FMOD_System_SetRecordDriver_Prototype (system.l, Driver.l)
   Global FMOD_System_SetRecordDriver.FMod_System_SetRecordDriver_Prototype
   FMOD_System_SetRecordDriver = GetFunction(fmodLib, "FMOD_System_SetRecordDriver")
   
   ;- FMOD_System_GetRecordDriver_
   Prototype.l FMOD_System_GetRecordDriver_Prototype (system.l, *Driver.Long)
   Global FMOD_System_GetRecordDriver.FMod_System_GetRecordDriver_Prototype
   FMOD_System_GetRecordDriver = GetFunction(fmodLib, "FMOD_System_GetRecordDriver")
   
   ;- FMOD_System_GetRecordNumDrivers_
   Prototype.l FMOD_System_GetRecordNumDrivers_Prototype (system.l, *Numdrivers.Long)
   Global FMOD_System_GetRecordNumDrivers.FMod_System_GetRecordNumDrivers_Prototype
   FMOD_System_GetRecordNumDrivers = GetFunction(fmodLib, "FMOD_System_GetRecordNumDrivers")
   
   ;- FMOD_System_GetRecordDriverName_
   Prototype.l FMOD_System_GetRecordDriverName_Prototype (system.l, id.l, *name.Byte, Namelen.l)
   Global FMOD_System_GetRecordDriverName.FMod_System_GetRecordDriverName_Prototype
   FMOD_System_GetRecordDriverName = GetFunction(fmodLib, "FMOD_System_GetRecordDriverName")
   
   ;- FMOD_System_GetRecordPosition_
   Prototype.l FMOD_System_GetRecordPosition_Prototype (system.l, *Position.Long)
   Global FMOD_System_GetRecordPosition.FMod_System_GetRecordPosition_Prototype
   FMOD_System_GetRecordPosition = GetFunction(fmodLib, "FMOD_System_GetRecordPosition")
   
   ;- FMOD_System_RecordStart_
   Prototype.l FMOD_System_RecordStart_Prototype (system.l, sound.l, Loop.l)
   Global FMOD_System_RecordStart.FMod_System_RecordStart_Prototype
   FMOD_System_RecordStart = GetFunction(fmodLib, "FMOD_System_RecordStart")
   
   ;- FMOD_System_RecordStop_
   Prototype.l FMOD_System_RecordStop_Prototype (system.l)
   Global FMOD_System_RecordStop.FMod_System_RecordStop_Prototype
   FMOD_System_RecordStop = GetFunction(fmodLib, "FMOD_System_RecordStop")
   
   ;- FMOD_System_IsRecording_
   Prototype.l FMOD_System_IsRecording_Prototype (system.l, *Recording.Long)
   Global FMOD_System_IsRecording.FMod_System_IsRecording_Prototype
   FMOD_System_IsRecording = GetFunction(fmodLib, "FMOD_System_IsRecording")
   
   ;- FMOD_System_CreateGeometry_
   Prototype.l FMOD_System_CreateGeometry_Prototype (system.l, MaxPolygons.l, MaxVertices.l, *Geometryf.Long)
   Global FMOD_System_CreateGeometry.FMod_System_CreateGeometry_Prototype
   FMOD_System_CreateGeometry = GetFunction(fmodLib, "FMOD_System_CreateGeometry")
   
   ;- FMOD_System_SetGeometrySettings_
   Prototype.l FMOD_System_SetGeometrySettings_Prototype (system.l, Maxworldsize.f)
   Global FMOD_System_SetGeometrySettings.FMod_System_SetGeometrySettings_Prototype
   FMOD_System_SetGeometrySettings = GetFunction(fmodLib, "FMOD_System_SetGeometrySettings")
   
   ;- FMOD_System_GetGeometrySettings_
   Prototype.l FMOD_System_GetGeometrySettings_Prototype (system.l, *Maxworldsize.Float)
   Global FMOD_System_GetGeometrySettings.FMod_System_GetGeometrySettings_Prototype
   FMOD_System_GetGeometrySettings = GetFunction(fmodLib, "FMOD_System_GetGeometrySettings")
   
   ;- FMOD_System_LoadGeometry_
   Prototype.l FMOD_System_LoadGeometry_Prototype (system.l, _data.l, _dataSize.l, *Geometry.Long)
   Global FMOD_System_LoadGeometry.FMod_System_LoadGeometry_Prototype
   FMOD_System_LoadGeometry = GetFunction(fmodLib, "FMOD_System_LoadGeometry")
   
   ;- FMOD_System_SetNetworkProxy_
   Prototype.l FMOD_System_SetNetworkProxy_Prototype (system.l, Proxy.s)
   Global FMOD_System_SetNetworkProxy.FMod_System_SetNetworkProxy_Prototype
   FMOD_System_SetNetworkProxy = GetFunction(fmodLib, "FMOD_System_SetNetworkProxy")
   
   ;- FMOD_System_GetNetworkProxy_
   Prototype.l FMOD_System_GetNetworkProxy_Prototype (system.l, *Proxy.Byte, Proxylen.l)
   Global FMOD_System_GetNetworkProxy.FMod_System_GetNetworkProxy_Prototype
   FMOD_System_GetNetworkProxy = GetFunction(fmodLib, "FMOD_System_GetNetworkProxy")
   
   ;- FMOD_System_SetNetworkTimeout_
   Prototype.l FMOD_System_SetNetworkTimeout_Prototype (system.l, timeout.l)
   Global FMOD_System_SetNetworkTimeout.FMod_System_SetNetworkTimeout_Prototype
   FMOD_System_SetNetworkTimeout = GetFunction(fmodLib, "FMOD_System_SetNetworkTimeout")
   
   ;- FMOD_System_GetNetworkTimeout_
   Prototype.l FMOD_System_GetNetworkTimeout_Prototype (system.l, *timeout.Long)
   Global FMOD_System_GetNetworkTimeout.FMod_System_GetNetworkTimeout_Prototype
   FMOD_System_GetNetworkTimeout = GetFunction(fmodLib, "FMOD_System_GetNetworkTimeout")
   
   ;- FMOD_System_SetUserData_
   Prototype.l FMOD_System_SetUserData_Prototype (system.l, userdata.l)
   Global FMOD_System_SetUserData.FMod_System_SetUserData_Prototype
   FMOD_System_SetUserData = GetFunction(fmodLib, "FMOD_System_SetUserData")
   
   ;- FMOD_System_GetUserData_
   Prototype.l FMOD_System_GetUserData_Prototype (system.l, *userdata.Long)
   Global FMOD_System_GetUserData.FMod_System_GetUserData_Prototype
   FMOD_System_GetUserData = GetFunction(fmodLib, "FMOD_System_GetUserData")
   
   ;- FMOD_Sound_Release_
   Prototype.l FMOD_Sound_Release_Prototype (sound.l)
   Global FMOD_Sound_Release.FMod_Sound_Release_Prototype
   FMOD_Sound_Release = GetFunction(fmodLib, "FMOD_Sound_Release")
   
   ;- FMOD_Sound_GetSystemObject_
   Prototype.l FMOD_Sound_GetSystemObject_Prototype (sound.l, *system.Long)
   Global FMOD_Sound_GetSystemObject.FMod_Sound_GetSystemObject_Prototype
   FMOD_Sound_GetSystemObject = GetFunction(fmodLib, "FMOD_Sound_GetSystemObject")
   
   ;- FMOD_Sound_Lock_
   Prototype.l FMOD_Sound_Lock_Prototype (sound.l, Offset.l, Length.l, *Ptr1.Long, *Ptr2.Long, *Len1.Long, *Len2.Long)
   Global FMOD_Sound_Lock.FMod_Sound_Lock_Prototype
   FMOD_Sound_Lock = GetFunction(fmodLib, "FMOD_Sound_Lock")
   
   ;- FMOD_Sound_Unlock_
   Prototype.l FMOD_Sound_Unlock_Prototype (sound.l, Ptr1.l, Ptr2.l, Len1.l, Len2.l)
   Global FMOD_Sound_Unlock.FMod_Sound_Unlock_Prototype
   FMOD_Sound_Unlock = GetFunction(fmodLib, "FMOD_Sound_Unlock")
   
   ;- FMOD_Sound_SetDefaults_
   Prototype.l FMOD_Sound_SetDefaults_Prototype (sound.l, Frequency.f, Volume.f, Pan.f, Priority.l)
   Global FMOD_Sound_SetDefaults.FMod_Sound_SetDefaults_Prototype
   FMOD_Sound_SetDefaults = GetFunction(fmodLib, "FMOD_Sound_SetDefaults")
   
   ;- FMOD_Sound_GetDefaults_
   Prototype.l FMOD_Sound_GetDefaults_Prototype (sound.l, *Frequency.Float, *Volume.Float, *Pan.Float, *Priority.Long)
   Global FMOD_Sound_GetDefaults.FMod_Sound_GetDefaults_Prototype
   FMOD_Sound_GetDefaults = GetFunction(fmodLib, "FMOD_Sound_GetDefaults")
   
   ;- FMOD_Sound_SetVariations_
   Prototype.l FMOD_Sound_SetVariations_Prototype (sound.l, Frequencyvar.f, Volumevar.f, Panvar.f)
   Global FMOD_Sound_SetVariations.FMod_Sound_SetVariations_Prototype
   FMOD_Sound_SetVariations = GetFunction(fmodLib, "FMOD_Sound_SetVariations")
   
   ;- FMOD_Sound_GetVariations_
   Prototype.l FMOD_Sound_GetVariations_Prototype (sound.l, *Frequencyvar.Float, *Volumevar.Float, *Panvar.Float)
   Global FMOD_Sound_GetVariations.FMod_Sound_GetVariations_Prototype
   FMOD_Sound_GetVariations = GetFunction(fmodLib, "FMOD_Sound_GetVariations")
   
   ;- FMOD_Sound_Set3DMinMaxDistance_
   Prototype.l FMOD_Sound_Set3DMinMaxDistance_Prototype (sound.l, min.f, max.f)
   Global FMOD_Sound_Set3DMinMaxDistance.FMod_Sound_Set3DMinMaxDistance_Prototype
   FMOD_Sound_Set3DMinMaxDistance = GetFunction(fmodLib, "FMOD_Sound_Set3DMinMaxDistance")
   
   ;- FMOD_Sound_Get3DMinMaxDistance_
   Prototype.l FMOD_Sound_Get3DMinMaxDistance_Prototype (sound.l, *min.Float, *max.Float)
   Global FMOD_Sound_Get3DMinMaxDistance.FMod_Sound_Get3DMinMaxDistance_Prototype
   FMOD_Sound_Get3DMinMaxDistance = GetFunction(fmodLib, "FMOD_Sound_Get3DMinMaxDistance")
   
   ;- FMOD_Sound_Set3DConeSettings_
   Prototype.l FMOD_Sound_Set3DConeSettings_Prototype (sound.l, Insideconeangle.f, Outsideconeangle.f, Outsidevolume.f)
   Global FMOD_Sound_Set3DConeSettings.FMod_Sound_Set3DConeSettings_Prototype
   FMOD_Sound_Set3DConeSettings = GetFunction(fmodLib, "FMOD_Sound_Set3DConeSettings")
   
   ;- FMOD_Sound_Get3DConeSettings_
   Prototype.l FMOD_Sound_Get3DConeSettings_Prototype (sound.l, *Insideconeangle.Float, *Outsideconeangle.Float, *Outsidevolume.Float)
   Global FMOD_Sound_Get3DConeSettings.FMod_Sound_Get3DConeSettings_Prototype
   FMOD_Sound_Get3DConeSettings = GetFunction(fmodLib, "FMOD_Sound_Get3DConeSettings")
   
   ;- FMOD_Sound_Set3DCustomRolloff_
   Prototype.l FMOD_Sound_Set3DCustomRolloff_Prototype (sound.l, *Points.Long, numpoints.l)
   Global FMOD_Sound_Set3DCustomRolloff.FMod_Sound_Set3DCustomRolloff_Prototype
   FMOD_Sound_Set3DCustomRolloff = GetFunction(fmodLib, "FMOD_Sound_Set3DCustomRolloff")
   
   ;- FMOD_Sound_Get3DCustomRolloff_
   Prototype.l FMOD_Sound_Get3DCustomRolloff_Prototype (sound.l, *Points.Long, *numpoints.Long)
   Global FMOD_Sound_Get3DCustomRolloff.FMod_Sound_Get3DCustomRolloff_Prototype
   FMOD_Sound_Get3DCustomRolloff = GetFunction(fmodLib, "FMOD_Sound_Get3DCustomRolloff")
   
   ;- FMOD_Sound_SetSubSound_
   Prototype.l FMOD_Sound_SetSubSound_Prototype (sound.l, Index.l, Subsound.l)
   Global FMOD_Sound_SetSubSound.FMod_Sound_SetSubSound_Prototype
   FMOD_Sound_SetSubSound = GetFunction(fmodLib, "FMOD_Sound_SetSubSound")
   
   ;- FMOD_Sound_GetSubSound_
   Prototype.l FMOD_Sound_GetSubSound_Prototype (sound.l, Index.l, *Subsound.Long)
   Global FMOD_Sound_GetSubSound.FMod_Sound_GetSubSound_Prototype
   FMOD_Sound_GetSubSound = GetFunction(fmodLib, "FMOD_Sound_GetSubSound")
   
   ;- FMOD_Sound_SetSubSoundSentence_
   Prototype.l FMOD_Sound_SetSubSoundSentence_Prototype (sound.l, *Subsoundlist.Long, Numsubsounds.l)
   Global FMOD_Sound_SetSubSoundSentence.FMod_Sound_SetSubSoundSentence_Prototype
   FMOD_Sound_SetSubSoundSentence = GetFunction(fmodLib, "FMOD_Sound_SetSubSoundSentence")
   
   ;- FMOD_Sound_GetName_
   Prototype.l FMOD_Sound_GetName_Prototype (sound.l, *name.Byte, Namelen.l)
   Global FMOD_Sound_GetName.FMod_Sound_GetName_Prototype
   FMOD_Sound_GetName = GetFunction(fmodLib, "FMOD_Sound_GetName")
   
   ;- FMOD_Sound_GetLength_
   Prototype.l FMOD_Sound_GetLength_Prototype (sound.l, *Length.Long, Lengthtype.l)
   Global FMOD_Sound_GetLength.FMod_Sound_GetLength_Prototype
   FMOD_Sound_GetLength = GetFunction(fmodLib, "FMOD_Sound_GetLength")
   
   ;- FMOD_Sound_GetFormat_
   Prototype.l FMOD_Sound_GetFormat_Prototype (sound.l, *Soundtype.Long, *Format.Long, *Channels.Long, *Bits.Long)
   Global FMOD_Sound_GetFormat.FMod_Sound_GetFormat_Prototype
   FMOD_Sound_GetFormat = GetFunction(fmodLib, "FMOD_Sound_GetFormat")
   
   ;- FMOD_Sound_GetNumSubSounds_
   Prototype.l FMOD_Sound_GetNumSubSounds_Prototype (sound.l, *Numsubsounds.Long)
   Global FMOD_Sound_GetNumSubSounds.FMod_Sound_GetNumSubSounds_Prototype
   FMOD_Sound_GetNumSubSounds = GetFunction(fmodLib, "FMOD_Sound_GetNumSubSounds")
   
   ;- FMOD_Sound_GetNumTags_
   Prototype.l FMOD_Sound_GetNumTags_Prototype (sound.l, *Numtags.Long, *Numtagsupdated.Long)
   Global FMOD_Sound_GetNumTags.FMod_Sound_GetNumTags_Prototype
   FMOD_Sound_GetNumTags = GetFunction(fmodLib, "FMOD_Sound_GetNumTags")
   
   ;- FMOD_Sound_GetTag_
   Prototype.l FMOD_Sound_GetTag_Prototype (sound.l, pNameOrNull.l, Index.l, *Tag.Long)
   Global FMOD_Sound_GetTag.FMod_Sound_GetTag_Prototype
   FMOD_Sound_GetTag = GetFunction(fmodLib, "FMOD_Sound_GetTag")
   
   ;- FMOD_Sound_GetOpenState_
   Prototype.l FMOD_Sound_GetOpenState_Prototype (sound.l, *Openstate.Long, *Percentbuffered.Long, *Starving.Long)
   Global FMOD_Sound_GetOpenState.FMod_Sound_GetOpenState_Prototype
   FMOD_Sound_GetOpenState = GetFunction(fmodLib, "FMOD_Sound_GetOpenState")
   
   ;- FMOD_Sound_ReadData_
   Prototype.l FMOD_Sound_ReadData_Prototype (sound.l, Buffer.l, Lenbytes.l, *_Read.Long)
   Global FMOD_Sound_ReadData.FMod_Sound_ReadData_Prototype
   FMOD_Sound_ReadData = GetFunction(fmodLib, "FMOD_Sound_ReadData")
   
   ;- FMOD_Sound_SeekData_
   Prototype.l FMOD_Sound_SeekData_Prototype (sound.l, Pcm.l)
   Global FMOD_Sound_SeekData.FMod_Sound_SeekData_Prototype
   FMOD_Sound_SeekData = GetFunction(fmodLib, "FMOD_Sound_SeekData")
   
   ;- FMOD_Sound_GetNumSyncPoints_
   Prototype.l FMOD_Sound_GetNumSyncPoints_Prototype (sound.l, *Numsyncpoints.Long)
   Global FMOD_Sound_GetNumSyncPoints.FMod_Sound_GetNumSyncPoints_Prototype
   FMOD_Sound_GetNumSyncPoints = GetFunction(fmodLib, "FMOD_Sound_GetNumSyncPoints")
   
   ;- FMOD_Sound_GetSyncPoint_
   Prototype.l FMOD_Sound_GetSyncPoint_Prototype (sound.l, Index.l, *Point.Long)
   Global FMOD_Sound_GetSyncPoint.FMod_Sound_GetSyncPoint_Prototype
   FMOD_Sound_GetSyncPoint = GetFunction(fmodLib, "FMOD_Sound_GetSyncPoint")
   
   ;- FMOD_Sound_GetSyncPointInfo_
   Prototype.l FMOD_Sound_GetSyncPointInfo_Prototype (sound.l, Point.l, *name.Byte, Namelen.l, *Offset.Long, Offsettype.l)
   Global FMOD_Sound_GetSyncPointInfo.FMod_Sound_GetSyncPointInfo_Prototype
   FMOD_Sound_GetSyncPointInfo = GetFunction(fmodLib, "FMOD_Sound_GetSyncPointInfo")
   
   ;- FMOD_Sound_AddSyncPoint_
   Prototype.l FMOD_Sound_AddSyncPoint_Prototype (sound.l, Offset.l, Offsettype.l, name.s, *Point.Long)
   Global FMOD_Sound_AddSyncPoint.FMod_Sound_AddSyncPoint_Prototype
   FMOD_Sound_AddSyncPoint = GetFunction(fmodLib, "FMOD_Sound_AddSyncPoint")
   
   ;- FMOD_Sound_DeleteSyncPoint_
   Prototype.l FMOD_Sound_DeleteSyncPoint_Prototype (sound.l, Point.l)
   Global FMOD_Sound_DeleteSyncPoint.FMod_Sound_DeleteSyncPoint_Prototype
   FMOD_Sound_DeleteSyncPoint = GetFunction(fmodLib, "FMOD_Sound_DeleteSyncPoint")
   
   ;- FMOD_Sound_SetMode_
   Prototype.l FMOD_Sound_SetMode_Prototype (sound.l, Mode.l)
   Global FMOD_Sound_SetMode.FMod_Sound_SetMode_Prototype
   FMOD_Sound_SetMode = GetFunction(fmodLib, "FMOD_Sound_SetMode")
   
   ;- FMOD_Sound_GetMode_
   Prototype.l FMOD_Sound_GetMode_Prototype (sound.l, *Mode.Long)
   Global FMOD_Sound_GetMode.FMod_Sound_GetMode_Prototype
   FMOD_Sound_GetMode = GetFunction(fmodLib, "FMOD_Sound_GetMode")
   
   ;- FMOD_Sound_SetLoopCount_
   Prototype.l FMOD_Sound_SetLoopCount_Prototype (sound.l, Loopcount.l)
   Global FMOD_Sound_SetLoopCount.FMod_Sound_SetLoopCount_Prototype
   FMOD_Sound_SetLoopCount = GetFunction(fmodLib, "FMOD_Sound_SetLoopCount")
   
   ;- FMOD_Sound_GetLoopCount_
   Prototype.l FMOD_Sound_GetLoopCount_Prototype (sound.l, *Loopcount.Long)
   Global FMOD_Sound_GetLoopCount.FMod_Sound_GetLoopCount_Prototype
   FMOD_Sound_GetLoopCount = GetFunction(fmodLib, "FMOD_Sound_GetLoopCount")
   
   ;- FMOD_Sound_SetLoopPoints_
   Prototype.l FMOD_Sound_SetLoopPoints_Prototype (sound.l, Loopstart.l, Loopstarttype.l, Loopend.l, Loopendtype.l)
   Global FMOD_Sound_SetLoopPoints.FMod_Sound_SetLoopPoints_Prototype
   FMOD_Sound_SetLoopPoints = GetFunction(fmodLib, "FMOD_Sound_SetLoopPoints")
   
   ;- FMOD_Sound_GetLoopPoints_
   Prototype.l FMOD_Sound_GetLoopPoints_Prototype (sound.l, *Loopstart.Long, Loopstarttype.l, *Loopend.Long, Loopendtype.l)
   Global FMOD_Sound_GetLoopPoints.FMod_Sound_GetLoopPoints_Prototype
   FMOD_Sound_GetLoopPoints = GetFunction(fmodLib, "FMOD_Sound_GetLoopPoints")
   
   ;- FMOD_Sound_SetUserData_
   Prototype.l FMOD_Sound_SetUserData_Prototype (sound.l, userdata.l)
   Global FMOD_Sound_SetUserData.FMod_Sound_SetUserData_Prototype
   FMOD_Sound_SetUserData = GetFunction(fmodLib, "FMOD_Sound_SetUserData")
   
   ;- FMOD_Sound_GetUserData_
   Prototype.l FMOD_Sound_GetUserData_Prototype (sound.l, *userdata.Long)
   Global FMOD_Sound_GetUserData.FMod_Sound_GetUserData_Prototype
   FMOD_Sound_GetUserData = GetFunction(fmodLib, "FMOD_Sound_GetUserData")
   
   ;- FMOD_Channel_GetSystemObject_
   Prototype.l FMOD_Channel_GetSystemObject_Prototype (channel.l, *system.Long)
   Global FMOD_Channel_GetSystemObject.FMod_Channel_GetSystemObject_Prototype
   FMOD_Channel_GetSystemObject = GetFunction(fmodLib, "FMOD_Channel_GetSystemObject")
   
   ;- FMOD_Channel_Stop_
   Prototype.l FMOD_Channel_Stop_Prototype (channel.l)
   Global FMOD_Channel_Stop.FMod_Channel_Stop_Prototype
   FMOD_Channel_Stop = GetFunction(fmodLib, "FMOD_Channel_Stop")
   
   ;- FMOD_Channel_SetPaused_
   Prototype.l FMOD_Channel_SetPaused_Prototype (channel.l, paused.l)
   Global FMOD_Channel_SetPaused.FMod_Channel_SetPaused_Prototype
   FMOD_Channel_SetPaused = GetFunction(fmodLib, "FMOD_Channel_SetPaused")
   
   ;- FMOD_Channel_GetPaused_
   Prototype.l FMOD_Channel_GetPaused_Prototype (channel.l, *paused.Long)
   Global FMOD_Channel_GetPaused.FMod_Channel_GetPaused_Prototype
   FMOD_Channel_GetPaused = GetFunction(fmodLib, "FMOD_Channel_GetPaused")
   
   ;- FMOD_Channel_SetVolume
   Prototype.l FMOD_Channel_SetVolume_Prototype(channel.l, Volume.f)
   Global FMOD_Channel_SetVolume.FMod_Channel_SetVolume_Prototype
   FMOD_Channel_SetVolume = GetFunction(fmodLib, "FMOD_Channel_SetVolume")
   
   ;- FMOD_Channel_GetVolume
   Prototype.l FMOD_Channel_GetVolume_Prototype(channel.l, *Volume.Float)
   Global FMOD_Channel_GetVolume.FMod_Channel_GetVolume_Prototype
   FMOD_Channel_GetVolume = GetFunction(fmodLib, "FMOD_Channel_GetVolume")
   
   ;- FMOD_Channel_SetFrequency_
   Prototype.l FMOD_Channel_SetFrequency_Prototype (channel.l, Frequency.f)
   Global FMOD_Channel_SetFrequency.FMod_Channel_SetFrequency_Prototype
   FMOD_Channel_SetFrequency = GetFunction(fmodLib, "FMOD_Channel_SetFrequency")
   
   ;- FMOD_Channel_GetFrequency_
   Prototype.l FMOD_Channel_GetFrequency_Prototype (channel.l, *Frequency.Float)
   Global FMOD_Channel_GetFrequency.FMod_Channel_GetFrequency_Prototype
   FMOD_Channel_GetFrequency = GetFunction(fmodLib, "FMOD_Channel_GetFrequency")
   
   ;- FMOD_Channel_SetPan_
   Prototype.l FMOD_Channel_SetPan_Prototype (channel.l, Pan.f)
   Global FMOD_Channel_SetPan.FMod_Channel_SetPan_Prototype
   FMOD_Channel_SetPan = GetFunction(fmodLib, "FMOD_Channel_SetPan")
   
   ;- FMOD_Channel_GetPan_
   Prototype.l FMOD_Channel_GetPan_Prototype (channel.l, *Pan.Float)
   Global FMOD_Channel_GetPan.FMod_Channel_GetPan_Prototype
   FMOD_Channel_GetPan = GetFunction(fmodLib, "FMOD_Channel_GetPan")
   
   ;- FMOD_Channel_SetDelay_
   Prototype.l FMOD_Channel_SetDelay_Prototype (channel.l, Startdelay.l, Enddelay.l)
   Global FMOD_Channel_SetDelay.FMod_Channel_SetDelay_Prototype
   FMOD_Channel_SetDelay = GetFunction(fmodLib, "FMOD_Channel_SetDelay")
   
   ;- FMOD_Channel_GetDelay_
   Prototype.l FMOD_Channel_GetDelay_Prototype (channel.l, *Startdelay.Long, *Enddelay.Long)
   Global FMOD_Channel_GetDelay.FMod_Channel_GetDelay_Prototype
   FMOD_Channel_GetDelay = GetFunction(fmodLib, "FMOD_Channel_GetDelay")
   
   ;- FMOD_Channel_SetSpeakerMix_
   Prototype.l FMOD_Channel_SetSpeakerMix_Prototype (channel.l, Frontleft.f, Frontright.f, Center.f, Lfe.f, Backleft.f, Backright.f, Sideleft.f, Sideright.f)
   Global FMOD_Channel_SetSpeakerMix.FMod_Channel_SetSpeakerMix_Prototype
   FMOD_Channel_SetSpeakerMix = GetFunction(fmodLib, "FMOD_Channel_SetSpeakerMix")
   
   ;- FMOD_Channel_GetSpeakerMix_
   Prototype.l FMOD_Channel_GetSpeakerMix_Prototype (channel.l, *Frontleft.Float, *Frontright.Float, *Center.Float, *Lfe.Float, *Backleft.Float, *Backright.Float, *Sideleft.Float, *Sideright.Float)
   Global FMOD_Channel_GetSpeakerMix.FMod_Channel_GetSpeakerMix_Prototype
   FMOD_Channel_GetSpeakerMix = GetFunction(fmodLib, "FMOD_Channel_GetSpeakerMix")
   
   ;- FMOD_Channel_SetSpeakerLevels_
   Prototype.l FMOD_Channel_SetSpeakerLevels_Prototype (channel.l, Speaker.l, *Levels.Float, Numlevels.l)
   Global FMOD_Channel_SetSpeakerLevels.FMod_Channel_SetSpeakerLevels_Prototype
   FMOD_Channel_SetSpeakerLevels = GetFunction(fmodLib, "FMOD_Channel_SetSpeakerLevels")
   
   ;- FMOD_Channel_GetSpeakerLevels_
   Prototype.l FMOD_Channel_GetSpeakerLevels_Prototype (channel.l, Speaker.l, *Levels.Float, Numlevels.l)
   Global FMOD_Channel_GetSpeakerLevels.FMod_Channel_GetSpeakerLevels_Prototype
   FMOD_Channel_GetSpeakerLevels = GetFunction(fmodLib, "FMOD_Channel_GetSpeakerLevels")
   
   ;- FMOD_Channel_SetMute_
   Prototype.l FMOD_Channel_SetMute_Prototype (channel.l, Mute.l)
   Global FMOD_Channel_SetMute.FMod_Channel_SetMute_Prototype
   FMOD_Channel_SetMute = GetFunction(fmodLib, "FMOD_Channel_SetMute")
   
   ;- FMOD_Channel_GetMute_
   Prototype.l FMOD_Channel_GetMute_Prototype (channel.l, *Mute.Long)
   Global FMOD_Channel_GetMute.FMod_Channel_GetMute_Prototype
   FMOD_Channel_GetMute = GetFunction(fmodLib, "FMOD_Channel_GetMute")
   
   ;- FMOD_Channel_SetPriority_
   Prototype.l FMOD_Channel_SetPriority_Prototype (channel.l, Priority.l)
   Global FMOD_Channel_SetPriority.FMod_Channel_SetPriority_Prototype
   FMOD_Channel_SetPriority = GetFunction(fmodLib, "FMOD_Channel_SetPriority")
   
   ;- FMOD_Channel_GetPriority_
   Prototype.l FMOD_Channel_GetPriority_Prototype (channel.l, *Priority.Long)
   Global FMOD_Channel_GetPriority.FMod_Channel_GetPriority_Prototype
   FMOD_Channel_GetPriority = GetFunction(fmodLib, "FMOD_Channel_GetPriority")
   
   ;- FMOD_Channel_SetPosition_
   Prototype.l FMOD_Channel_SetPosition_Prototype (channel.l, Position.l, Postype.l)
   Global FMOD_Channel_SetPosition.FMod_Channel_SetPosition_Prototype
   FMOD_Channel_SetPosition = GetFunction(fmodLib, "FMOD_Channel_SetPosition")
   
   ;- FMOD_Channel_GetPosition_
   Prototype.l FMOD_Channel_GetPosition_Prototype (channel.l, *Position.Long, Postype.l)
   Global FMOD_Channel_GetPosition.FMod_Channel_GetPosition_Prototype
   FMOD_Channel_GetPosition = GetFunction(fmodLib, "FMOD_Channel_GetPosition")
   
   ;- FMOD_Channel_SetReverbProperties_
   Prototype.l FMOD_Channel_SetReverbProperties_Prototype (channel.l, *Prop.Long)
   Global FMOD_Channel_SetReverbProperties.FMod_Channel_SetReverbProperties_Prototype
   FMOD_Channel_SetReverbProperties = GetFunction(fmodLib, "FMOD_Channel_SetReverbProperties")
   
   ;- FMOD_Channel_GetReverbProperties_
   Prototype.l FMOD_Channel_GetReverbProperties_Prototype (channel.l, *Prop.Long)
   Global FMOD_Channel_GetReverbProperties.FMod_Channel_GetReverbProperties_Prototype
   FMOD_Channel_GetReverbProperties = GetFunction(fmodLib, "FMOD_Channel_GetReverbProperties")
   
   ;- FMOD_Channel_SetChannelGroup_
   Prototype.l FMOD_Channel_SetChannelGroup_Prototype (channel.l, Channelgroup.l)
   Global FMOD_Channel_SetChannelGroup.FMod_Channel_SetChannelGroup_Prototype
   FMOD_Channel_SetChannelGroup = GetFunction(fmodLib, "FMOD_Channel_SetChannelGroup")
   
   ;- FMOD_Channel_GetChannelGroup_
   Prototype.l FMOD_Channel_GetChannelGroup_Prototype (channel.l, *Channelgroup.Long)
   Global FMOD_Channel_GetChannelGroup.FMod_Channel_GetChannelGroup_Prototype
   FMOD_Channel_GetChannelGroup = GetFunction(fmodLib, "FMOD_Channel_GetChannelGroup")
   
   ;- FMOD_Channel_SetCallback_
   Prototype.l FMOD_Channel_SetCallback_Prototype (channel.l, Type.l, Callback.l, Command.l)
   Global FMOD_Channel_SetCallback.FMod_Channel_SetCallback_Prototype
   FMOD_Channel_SetCallback = GetFunction(fmodLib, "FMOD_Channel_SetCallback")
   
   ;- FMOD_Channel_Set3DAttributes_
   Prototype.l FMOD_Channel_Set3DAttributes_Prototype (channel.l, *Pos.Long, *Vel.Long)
   Global FMOD_Channel_Set3DAttributes.FMod_Channel_Set3DAttributes_Prototype
   FMOD_Channel_Set3DAttributes = GetFunction(fmodLib, "FMOD_Channel_Set3DAttributes")
   
   ;- FMOD_Channel_Get3DAttributes_
   Prototype.l FMOD_Channel_Get3DAttributes_Prototype (channel.l, *Pos.Long, *Vel.Long)
   Global FMOD_Channel_Get3DAttributes.FMod_Channel_Get3DAttributes_Prototype
   FMOD_Channel_Get3DAttributes = GetFunction(fmodLib, "FMOD_Channel_Get3DAttributes")
   
   ;- FMOD_Channel_Set3DMinMaxDistance_
   Prototype.l FMOD_Channel_Set3DMinMaxDistance_Prototype (channel.l, Mindistance.f, Maxdistance.f)
   Global FMOD_Channel_Set3DMinMaxDistance.FMod_Channel_Set3DMinMaxDistance_Prototype
   FMOD_Channel_Set3DMinMaxDistance = GetFunction(fmodLib, "FMOD_Channel_Set3DMinMaxDistance")
   
   ;- FMOD_Channel_Get3DMinMaxDistance_
   Prototype.l FMOD_Channel_Get3DMinMaxDistance_Prototype (channel.l, *Mindistance.Float, *Maxdistance.Float)
   Global FMOD_Channel_Get3DMinMaxDistance.FMod_Channel_Get3DMinMaxDistance_Prototype
   FMOD_Channel_Get3DMinMaxDistance = GetFunction(fmodLib, "FMOD_Channel_Get3DMinMaxDistance")
   
   ;- FMOD_Channel_Set3DConeSettings_
   Prototype.l FMOD_Channel_Set3DConeSettings_Prototype (channel.l, Insideconeangle.f, Outsideconeangle.f, Outsidevolume.f)
   Global FMOD_Channel_Set3DConeSettings.FMod_Channel_Set3DConeSettings_Prototype
   FMOD_Channel_Set3DConeSettings = GetFunction(fmodLib, "FMOD_Channel_Set3DConeSettings")
   
   ;- FMOD_Channel_Get3DConeSettings_
   Prototype.l FMOD_Channel_Get3DConeSettings_Prototype (channel.l, *Insideconeangle.Float, *Outsideconeangle.Float, *Outsidevolume.Float)
   Global FMOD_Channel_Get3DConeSettings.FMod_Channel_Get3DConeSettings_Prototype
   FMOD_Channel_Get3DConeSettings = GetFunction(fmodLib, "FMOD_Channel_Get3DConeSettings")
   
   ;- FMOD_Channel_Set3DConeOrientation_
   Prototype.l FMOD_Channel_Set3DConeOrientation_Prototype (channel.l, *Orientation.Long)
   Global FMOD_Channel_Set3DConeOrientation.FMod_Channel_Set3DConeOrientation_Prototype
   FMOD_Channel_Set3DConeOrientation = GetFunction(fmodLib, "FMOD_Channel_Set3DConeOrientation")
   
   ;- FMOD_Channel_Get3DConeOrientation_
   Prototype.l FMOD_Channel_Get3DConeOrientation_Prototype (channel.l, *Orientation.Long)
   Global FMOD_Channel_Get3DConeOrientation.FMod_Channel_Get3DConeOrientation_Prototype
   FMOD_Channel_Get3DConeOrientation = GetFunction(fmodLib, "FMOD_Channel_Get3DConeOrientation")
   
   ;- FMOD_Channel_Set3DCustomRolloff_
   Prototype.l FMOD_Channel_Set3DCustomRolloff_Prototype (channel.l, *Points.Long, numpoints.l)
   Global FMOD_Channel_Set3DCustomRolloff.FMod_Channel_Set3DCustomRolloff_Prototype
   FMOD_Channel_Set3DCustomRolloff = GetFunction(fmodLib, "FMOD_Channel_Set3DCustomRolloff")
   
   ;- FMOD_Channel_Get3DCustomRolloff_
   Prototype.l FMOD_Channel_Get3DCustomRolloff_Prototype (channel.l, *Points.Long, *numpoints.Long)
   Global FMOD_Channel_Get3DCustomRolloff.FMod_Channel_Get3DCustomRolloff_Prototype
   FMOD_Channel_Get3DCustomRolloff = GetFunction(fmodLib, "FMOD_Channel_Get3DCustomRolloff")
   
   ;- FMOD_Channel_Set3DOcclusion_
   Prototype.l FMOD_Channel_Set3DOcclusion_Prototype (channel.l, DirectOcclusion.f, ReverbOcclusion.f)
   Global FMOD_Channel_Set3DOcclusion.FMod_Channel_Set3DOcclusion_Prototype
   FMOD_Channel_Set3DOcclusion = GetFunction(fmodLib, "FMOD_Channel_Set3DOcclusion")
   
   ;- FMOD_Channel_Get3DOcclusion_
   Prototype.l FMOD_Channel_Get3DOcclusion_Prototype (channel.l, *DirectOcclusion.Float, *ReverbOcclusion.Float)
   Global FMOD_Channel_Get3DOcclusion.FMod_Channel_Get3DOcclusion_Prototype
   FMOD_Channel_Get3DOcclusion = GetFunction(fmodLib, "FMOD_Channel_Get3DOcclusion")
   
   ;- FMOD_Channel_Set3DSpread_
   Prototype.l FMOD_Channel_Set3DSpread_Prototype (channel.l, angle.f)
   Global FMOD_Channel_Set3DSpread.FMod_Channel_Set3DSpread_Prototype
   FMOD_Channel_Set3DSpread = GetFunction(fmodLib, "FMOD_Channel_Set3DSpread")
   
   ;- FMOD_Channel_Get3DSpread_
   Prototype.l FMOD_Channel_Get3DSpread_Prototype (channel.l, *angle.Float)
   Global FMOD_Channel_Get3DSpread.FMod_Channel_Get3DSpread_Prototype
   FMOD_Channel_Get3DSpread = GetFunction(fmodLib, "FMOD_Channel_Get3DSpread")
   
   ;- FMOD_Channel_Set3DPanLevel_
   Prototype.l FMOD_Channel_Set3DPanLevel_Prototype (channel.l, float.f)
   Global FMOD_Channel_Set3DPanLevel.FMod_Channel_Set3DPanLevel_Prototype
   FMOD_Channel_Set3DPanLevel = GetFunction(fmodLib, "FMOD_Channel_Set3DPanLevel")
   
   ;- FMOD_Channel_Get3DPanLevel_
   Prototype.l FMOD_Channel_Get3DPanLevel_Prototype (channel.l, *float.Float)
   Global FMOD_Channel_Get3DPanLevel.FMod_Channel_Get3DPanLevel_Prototype
   FMOD_Channel_Get3DPanLevel = GetFunction(fmodLib, "FMOD_Channel_Get3DPanLevel")
   
   ;- FMOD_Channel_Set3DDopplerLevel_
   Prototype.l FMOD_Channel_Set3DDopplerLevel_Prototype (channel.l, level.f)
   Global FMOD_Channel_Set3DDopplerLevel.FMod_Channel_Set3DDopplerLevel_Prototype
   FMOD_Channel_Set3DDopplerLevel = GetFunction(fmodLib, "FMOD_Channel_Set3DDopplerLevel")
   
   ;- FMOD_Channel_Get3DDopplerLevel_
   Prototype.l FMOD_Channel_Get3DDopplerLevel_Prototype (channel.l, *level.Float)
   Global FMOD_Channel_Get3DDopplerLevel.FMod_Channel_Get3DDopplerLevel_Prototype
   FMOD_Channel_Get3DDopplerLevel = GetFunction(fmodLib, "FMOD_Channel_Get3DDopplerLevel")
   
   ;- FMOD_Channel_GetDSPHead_
   Prototype.l FMOD_Channel_GetDSPHead_Prototype (channel.l, *Dsp.Long)
   Global FMOD_Channel_GetDSPHead.FMod_Channel_GetDSPHead_Prototype
   FMOD_Channel_GetDSPHead = GetFunction(fmodLib, "FMOD_Channel_GetDSPHead")
   
   ;- FMOD_Channel_AddDSP_
   Prototype.l FMOD_Channel_AddDSP_Prototype (channel.l, Dsp.l)
   Global FMOD_Channel_AddDSP.FMod_Channel_AddDSP_Prototype
   FMOD_Channel_AddDSP = GetFunction(fmodLib, "FMOD_Channel_AddDSP")
   
   ;- FMOD_Channel_IsPlaying_
   Prototype.l FMOD_Channel_IsPlaying_Prototype (channel.l, *Isplaying.Long)
   Global FMOD_Channel_IsPlaying.FMod_Channel_IsPlaying_Prototype
   FMOD_Channel_IsPlaying = GetFunction(fmodLib, "FMOD_Channel_IsPlaying")
   
   ;- FMOD_Channel_IsVirtual_
   Prototype.l FMOD_Channel_IsVirtual_Prototype (channel.l, *Isvirtual.Long)
   Global FMOD_Channel_IsVirtual.FMod_Channel_IsVirtual_Prototype
   FMOD_Channel_IsVirtual = GetFunction(fmodLib, "FMOD_Channel_IsVirtual")
   
   ;- FMOD_Channel_GetAudibility_
   Prototype.l FMOD_Channel_GetAudibility_Prototype (channel.l, *Audibility.Float)
   Global FMOD_Channel_GetAudibility.FMod_Channel_GetAudibility_Prototype
   FMOD_Channel_GetAudibility = GetFunction(fmodLib, "FMOD_Channel_GetAudibility")
   
   ;- FMOD_Channel_GetCurrentSound_
   Prototype.l FMOD_Channel_GetCurrentSound_Prototype (channel.l, *Sound.Long)
   Global FMOD_Channel_GetCurrentSound.FMod_Channel_GetCurrentSound_Prototype
   FMOD_Channel_GetCurrentSound = GetFunction(fmodLib, "FMOD_Channel_GetCurrentSound")
   
   ;- FMOD_Channel_GetSpectrum_
   Prototype.l FMOD_Channel_GetSpectrum_Prototype (channel.l, *Spectrumarray.Float, Numvalues.l, Channeloffset.l, Windowtype.l)
   Global FMOD_Channel_GetSpectrum.FMod_Channel_GetSpectrum_Prototype
   FMOD_Channel_GetSpectrum = GetFunction(fmodLib, "FMOD_Channel_GetSpectrum")
   
   ;- FMOD_Channel_GetWaveData_
   Prototype.l FMOD_Channel_GetWaveData_Prototype (channel.l, *Wavearray.Float, Numvalues.l, Channeloffset.l)
   Global FMOD_Channel_GetWaveData.FMod_Channel_GetWaveData_Prototype
   FMOD_Channel_GetWaveData = GetFunction(fmodLib, "FMOD_Channel_GetWaveData")
   
   ;- FMOD_Channel_GetIndex_
   Prototype.l FMOD_Channel_GetIndex_Prototype (channel.l, *Index.Long)
   Global FMOD_Channel_GetIndex.FMod_Channel_GetIndex_Prototype
   FMOD_Channel_GetIndex = GetFunction(fmodLib, "FMOD_Channel_GetIndex")
   
   ;- FMOD_Channel_SetMode_
   Prototype.l FMOD_Channel_SetMode_Prototype (channel.l, Mode.l)
   Global FMOD_Channel_SetMode.FMod_Channel_SetMode_Prototype
   FMOD_Channel_SetMode = GetFunction(fmodLib, "FMOD_Channel_SetMode")
   
   ;- FMOD_Channel_GetMode_
   Prototype.l FMOD_Channel_GetMode_Prototype (channel.l, *Mode.Long)
   Global FMOD_Channel_GetMode.FMod_Channel_GetMode_Prototype
   FMOD_Channel_GetMode = GetFunction(fmodLib, "FMOD_Channel_GetMode")
   
   ;- FMOD_Channel_SetLoopCount_
   Prototype.l FMOD_Channel_SetLoopCount_Prototype (channel.l, Loopcount.l)
   Global FMOD_Channel_SetLoopCount.FMod_Channel_SetLoopCount_Prototype
   FMOD_Channel_SetLoopCount = GetFunction(fmodLib, "FMOD_Channel_SetLoopCount")
   
   ;- FMOD_Channel_GetLoopCount_
   Prototype.l FMOD_Channel_GetLoopCount_Prototype (channel.l, *Loopcount.Long)
   Global FMOD_Channel_GetLoopCount.FMod_Channel_GetLoopCount_Prototype
   FMOD_Channel_GetLoopCount = GetFunction(fmodLib, "FMOD_Channel_GetLoopCount")
   
   ;- FMOD_Channel_SetLoopPoints_
   Prototype.l FMOD_Channel_SetLoopPoints_Prototype (channel.l, Loopstart.l, Loopstarttype.l, Loopend.l, Loopendtype.l)
   Global FMOD_Channel_SetLoopPoints.FMod_Channel_SetLoopPoints_Prototype
   FMOD_Channel_SetLoopPoints = GetFunction(fmodLib, "FMOD_Channel_SetLoopPoints")
   
   ;- FMOD_Channel_GetLoopPoints_
   Prototype.l FMOD_Channel_GetLoopPoints_Prototype (channel.l, *Loopstart.Long, Loopstarttype.l, *Loopend.Long, Loopendtype.l)
   Global FMOD_Channel_GetLoopPoints.FMod_Channel_GetLoopPoints_Prototype
   FMOD_Channel_GetLoopPoints = GetFunction(fmodLib, "FMOD_Channel_GetLoopPoints")
   
   ;- FMOD_Channel_SetUserData_
   Prototype.l FMOD_Channel_SetUserData_Prototype (channel.l, userdata.l)
   Global FMOD_Channel_SetUserData.FMod_Channel_SetUserData_Prototype
   FMOD_Channel_SetUserData = GetFunction(fmodLib, "FMOD_Channel_SetUserData")
   
   ;- FMOD_Channel_GetUserData_
   Prototype.l FMOD_Channel_GetUserData_Prototype (channel.l, *userdata.Long)
   Global FMOD_Channel_GetUserData.FMod_Channel_GetUserData_Prototype
   FMOD_Channel_GetUserData = GetFunction(fmodLib, "FMOD_Channel_GetUserData")
   
   ;- FMOD_ChannelGroup_Release_
   Prototype.l FMOD_ChannelGroup_Release_Prototype (Channelgroup.l)
   Global FMOD_ChannelGroup_Release.FMod_ChannelGroup_Release_Prototype
   FMOD_ChannelGroup_Release = GetFunction(fmodLib, "FMOD_ChannelGroup_Release")
   
   ;- FMOD_ChannelGroup_GetSystemObject_
   Prototype.l FMOD_ChannelGroup_GetSystemObject_Prototype (Channelgroup.l, *system.Long)
   Global FMOD_ChannelGroup_GetSystemObject.FMod_ChannelGroup_GetSystemObject_Prototype
   FMOD_ChannelGroup_GetSystemObject = GetFunction(fmodLib, "FMOD_ChannelGroup_GetSystemObject")
   
   ;- FMOD_ChannelGroup_SetVolume_
   Prototype.l FMOD_ChannelGroup_SetVolume_Prototype (Channelgroup.l, Volume.f)
   Global FMOD_ChannelGroup_SetVolume.FMod_ChannelGroup_SetVolume_Prototype
   FMOD_ChannelGroup_SetVolume = GetFunction(fmodLib, "FMOD_ChannelGroup_SetVolume")
   
   ;- FMOD_ChannelGroup_GetVolume_
   Prototype.l FMOD_ChannelGroup_GetVolume_Prototype (Channelgroup.l, *Volume.Float)
   Global FMOD_ChannelGroup_GetVolume.FMod_ChannelGroup_GetVolume_Prototype
   FMOD_ChannelGroup_GetVolume = GetFunction(fmodLib, "FMOD_ChannelGroup_GetVolume")
   
   ;- FMOD_ChannelGroup_SetPitch_
   Prototype.l FMOD_ChannelGroup_SetPitch_Prototype (Channelgroup.l, Pitch.f)
   Global FMOD_ChannelGroup_SetPitch.FMod_ChannelGroup_SetPitch_Prototype
   FMOD_ChannelGroup_SetPitch = GetFunction(fmodLib, "FMOD_ChannelGroup_SetPitch")
   
   ;- FMOD_ChannelGroup_GetPitch_
   Prototype.l FMOD_ChannelGroup_GetPitch_Prototype (Channelgroup.l, *Pitch.Float)
   Global FMOD_ChannelGroup_GetPitch.FMod_ChannelGroup_GetPitch_Prototype
   FMOD_ChannelGroup_GetPitch = GetFunction(fmodLib, "FMOD_ChannelGroup_GetPitch")
   
   ;- FMOD_ChannelGroup_Stop_
   Prototype.l FMOD_ChannelGroup_Stop_Prototype (Channelgroup.l)
   Global FMOD_ChannelGroup_Stop.FMod_ChannelGroup_Stop_Prototype
   FMOD_ChannelGroup_Stop = GetFunction(fmodLib, "FMOD_ChannelGroup_Stop")
   
   ;- FMOD_ChannelGroup_OverrideVolume_
   Prototype.l FMOD_ChannelGroup_OverrideVolume_Prototype (Channelgroup.l, Volume.f)
   Global FMOD_ChannelGroup_OverrideVolume.FMod_ChannelGroup_OverrideVolume_Prototype
   FMOD_ChannelGroup_OverrideVolume = GetFunction(fmodLib, "FMOD_ChannelGroup_OverrideVolume")
   
   ;- FMOD_ChannelGroup_OverridePaused_
   Prototype.l FMOD_ChannelGroup_OverridePaused_Prototype (Channelgroup.l, paused.l)
   Global FMOD_ChannelGroup_OverridePaused.FMod_ChannelGroup_OverridePaused_Prototype
   FMOD_ChannelGroup_OverridePaused = GetFunction(fmodLib, "FMOD_ChannelGroup_OverridePaused")
   
   ;- FMOD_ChannelGroup_OverrideFrequency_
   Prototype.l FMOD_ChannelGroup_OverrideFrequency_Prototype (Channelgroup.l, Frequency.f)
   Global FMOD_ChannelGroup_OverrideFrequency.FMod_ChannelGroup_OverrideFrequency_Prototype
   FMOD_ChannelGroup_OverrideFrequency = GetFunction(fmodLib, "FMOD_ChannelGroup_OverrideFrequency")
   
   ;- FMOD_ChannelGroup_OverridePan_
   Prototype.l FMOD_ChannelGroup_OverridePan_Prototype (Channelgroup.l, Pan.f)
   Global FMOD_ChannelGroup_OverridePan.FMod_ChannelGroup_OverridePan_Prototype
   FMOD_ChannelGroup_OverridePan = GetFunction(fmodLib, "FMOD_ChannelGroup_OverridePan")
   
   ;- FMOD_ChannelGroup_OverrideMute_
   Prototype.l FMOD_ChannelGroup_OverrideMute_Prototype (Channelgroup.l, Mute.l)
   Global FMOD_ChannelGroup_OverrideMute.FMod_ChannelGroup_OverrideMute_Prototype
   FMOD_ChannelGroup_OverrideMute = GetFunction(fmodLib, "FMOD_ChannelGroup_OverrideMute")
   
   ;- FMOD_ChannelGroup_OverrideReverbProperties_
   Prototype.l FMOD_ChannelGroup_OverrideReverbProperties_Prototype (Channelgroup.l, *Prop.Long)
   Global FMOD_ChannelGroup_OverrideReverbProperties.FMod_ChannelGroup_OverrideReverbProperties_Prototype
   FMOD_ChannelGroup_OverrideReverbProperties = GetFunction(fmodLib, "FMOD_ChannelGroup_OverrideReverbProperties")
   
   ;- FMOD_ChannelGroup_Override3DAttributes_
   Prototype.l FMOD_ChannelGroup_Override3DAttributes_Prototype (Channelgroup.l, *Pos.Long, *Vel.Long)
   Global FMOD_ChannelGroup_Override3DAttributes.FMod_ChannelGroup_Override3DAttributes_Prototype
   FMOD_ChannelGroup_Override3DAttributes = GetFunction(fmodLib, "FMOD_ChannelGroup_Override3DAttributes")
   
   ;- FMOD_ChannelGroup_OverrideSpeakerMix_
   Prototype.l FMOD_ChannelGroup_OverrideSpeakerMix_Prototype (Channelgroup.l, Frontleft.f, Frontright.f, Center.f, Lfe.f, Backleft.f, Backright.f, Sideleft.f, Sideright.f)
   Global FMOD_ChannelGroup_OverrideSpeakerMix.FMod_ChannelGroup_OverrideSpeakerMix_Prototype
   FMOD_ChannelGroup_OverrideSpeakerMix = GetFunction(fmodLib, "FMOD_ChannelGroup_OverrideSpeakerMix")
   
   ;- FMOD_ChannelGroup_AddGroup_
   Prototype.l FMOD_ChannelGroup_AddGroup_Prototype (Channelgroup.l, Group.l)
   Global FMOD_ChannelGroup_AddGroup.FMod_ChannelGroup_AddGroup_Prototype
   FMOD_ChannelGroup_AddGroup = GetFunction(fmodLib, "FMOD_ChannelGroup_AddGroup")
   
   ;- FMOD_ChannelGroup_GetNumGroups_
   Prototype.l FMOD_ChannelGroup_GetNumGroups_Prototype (Channelgroup.l, *Numgroups.Long)
   Global FMOD_ChannelGroup_GetNumGroups.FMod_ChannelGroup_GetNumGroups_Prototype
   FMOD_ChannelGroup_GetNumGroups = GetFunction(fmodLib, "FMOD_ChannelGroup_GetNumGroups")
   
   ;- FMOD_ChannelGroup_GetGroup_
   Prototype.l FMOD_ChannelGroup_GetGroup_Prototype (Channelgroup.l, Index.l, *Group.Long)
   Global FMOD_ChannelGroup_GetGroup.FMod_ChannelGroup_GetGroup_Prototype
   FMOD_ChannelGroup_GetGroup = GetFunction(fmodLib, "FMOD_ChannelGroup_GetGroup")
   
   ;- FMOD_ChannelGroup_GetDSPHead_
   Prototype.l FMOD_ChannelGroup_GetDSPHead_Prototype (Channelgroup.l, *Dsp.Long)
   Global FMOD_ChannelGroup_GetDSPHead.FMod_ChannelGroup_GetDSPHead_Prototype
   FMOD_ChannelGroup_GetDSPHead = GetFunction(fmodLib, "FMOD_ChannelGroup_GetDSPHead")
   
   ;- FMOD_ChannelGroup_AddDSP_
   Prototype.l FMOD_ChannelGroup_AddDSP_Prototype (Channelgroup.l, Dsp.l)
   Global FMOD_ChannelGroup_AddDSP.FMod_ChannelGroup_AddDSP_Prototype
   FMOD_ChannelGroup_AddDSP = GetFunction(fmodLib, "FMOD_ChannelGroup_AddDSP")
   
   ;- FMOD_ChannelGroup_GetName_
   Prototype.l FMOD_ChannelGroup_GetName_Prototype (Channelgroup.l, *name.Byte, Namelen.l)
   Global FMOD_ChannelGroup_GetName.FMod_ChannelGroup_GetName_Prototype
   FMOD_ChannelGroup_GetName = GetFunction(fmodLib, "FMOD_ChannelGroup_GetName")
   
   ;- FMOD_ChannelGroup_GetNumChannels_
   Prototype.l FMOD_ChannelGroup_GetNumChannels_Prototype (Channelgroup.l, *Numchannels.Long)
   Global FMOD_ChannelGroup_GetNumChannels.FMod_ChannelGroup_GetNumChannels_Prototype
   FMOD_ChannelGroup_GetNumChannels = GetFunction(fmodLib, "FMOD_ChannelGroup_GetNumChannels")
   
   ;- FMOD_ChannelGroup_GetChannel_
   Prototype.l FMOD_ChannelGroup_GetChannel_Prototype (Channelgroup.l, Index.l, *channel.Long)
   Global FMOD_ChannelGroup_GetChannel.FMod_ChannelGroup_GetChannel_Prototype
   FMOD_ChannelGroup_GetChannel = GetFunction(fmodLib, "FMOD_ChannelGroup_GetChannel")
   
   ;- FMOD_ChannelGroup_GetSpectrum_
   Prototype.l FMOD_ChannelGroup_GetSpectrum_Prototype (Channelgroup.l, *Spectrumarray.Float, Numvalues.l, Channeloffset.l, Windowtype.l)
   Global FMOD_ChannelGroup_GetSpectrum.FMod_ChannelGroup_GetSpectrum_Prototype
   FMOD_ChannelGroup_GetSpectrum = GetFunction(fmodLib, "FMOD_ChannelGroup_GetSpectrum")
   
   ;- FMOD_ChannelGroup_GetWaveData_
   Prototype.l FMOD_ChannelGroup_GetWaveData_Prototype (Channelgroup.l, *Wavearray.Float, Numvalues.l, Channeloffset.l)
   Global FMOD_ChannelGroup_GetWaveData.FMod_ChannelGroup_GetWaveData_Prototype
   FMOD_ChannelGroup_GetWaveData = GetFunction(fmodLib, "FMOD_ChannelGroup_GetWaveData")
   
   ;- FMOD_ChannelGroup_SetUserData_
   Prototype.l FMOD_ChannelGroup_SetUserData_Prototype (Channelgroup.l, userdata.l)
   Global FMOD_ChannelGroup_SetUserData.FMod_ChannelGroup_SetUserData_Prototype
   FMOD_ChannelGroup_SetUserData = GetFunction(fmodLib, "FMOD_ChannelGroup_SetUserData")
   
   ;- FMOD_ChannelGroup_GetUserData_
   Prototype.l FMOD_ChannelGroup_GetUserData_Prototype (Channelgroup.l, *userdata.Long)
   Global FMOD_ChannelGroup_GetUserData.FMod_ChannelGroup_GetUserData_Prototype
   FMOD_ChannelGroup_GetUserData = GetFunction(fmodLib, "FMOD_ChannelGroup_GetUserData")
   
   ;- FMOD_DSP_Release_
   Prototype.l FMOD_DSP_Release_Prototype (Dsp.l)
   Global FMOD_DSP_Release.FMod_DSP_Release_Prototype
   FMOD_DSP_Release = GetFunction(fmodLib, "FMOD_DSP_Release")
   
   ;- FMOD_DSP_GetSystemObject_
   Prototype.l FMOD_DSP_GetSystemObject_Prototype (Dsp.l, *system.Long)
   Global FMOD_DSP_GetSystemObject.FMod_DSP_GetSystemObject_Prototype
   FMOD_DSP_GetSystemObject = GetFunction(fmodLib, "FMOD_DSP_GetSystemObject")
   
   ;- FMOD_DSP_AddInput_
   Prototype.l FMOD_DSP_AddInput_Prototype (Dsp.l, Target.l)
   Global FMOD_DSP_AddInput.FMod_DSP_AddInput_Prototype
   FMOD_DSP_AddInput = GetFunction(fmodLib, "FMOD_DSP_AddInput")
   
   ;- FMOD_DSP_DisconnectFrom_
   Prototype.l FMOD_DSP_DisconnectFrom_Prototype (Dsp.l, Target.l)
   Global FMOD_DSP_DisconnectFrom.FMod_DSP_DisconnectFrom_Prototype
   FMOD_DSP_DisconnectFrom = GetFunction(fmodLib, "FMOD_DSP_DisconnectFrom")
   
   ;- FMOD_DSP_Remove_
   Prototype.l FMOD_DSP_Remove_Prototype (Dsp.l)
   Global FMOD_DSP_Remove.FMod_DSP_Remove_Prototype
   FMOD_DSP_Remove = GetFunction(fmodLib, "FMOD_DSP_Remove")
   
   ;- FMOD_DSP_GetNumInputs_
   Prototype.l FMOD_DSP_GetNumInputs_Prototype (Dsp.l, *Numinputs.Long)
   Global FMOD_DSP_GetNumInputs.FMod_DSP_GetNumInputs_Prototype
   FMOD_DSP_GetNumInputs = GetFunction(fmodLib, "FMOD_DSP_GetNumInputs")
   
   ;- FMOD_DSP_GetNumOutputs_
   Prototype.l FMOD_DSP_GetNumOutputs_Prototype (Dsp.l, *Numoutputs.Long)
   Global FMOD_DSP_GetNumOutputs.FMod_DSP_GetNumOutputs_Prototype
   FMOD_DSP_GetNumOutputs = GetFunction(fmodLib, "FMOD_DSP_GetNumOutputs")
   
   ;- FMOD_DSP_GetInput_
   Prototype.l FMOD_DSP_GetInput_Prototype (Dsp.l, Index.l, *Input.Long)
   Global FMOD_DSP_GetInput.FMod_DSP_GetInput_Prototype
   FMOD_DSP_GetInput = GetFunction(fmodLib, "FMOD_DSP_GetInput")
   
   ;- FMOD_DSP_GetOutput_
   Prototype.l FMOD_DSP_GetOutput_Prototype (Dsp.l, Index.l, *Output.Long)
   Global FMOD_DSP_GetOutput.FMod_DSP_GetOutput_Prototype
   FMOD_DSP_GetOutput = GetFunction(fmodLib, "FMOD_DSP_GetOutput")
   
   ;- FMOD_DSP_SetInputMix_
   Prototype.l FMOD_DSP_SetInputMix_Prototype (Dsp.l, Index.l, Volume.f)
   Global FMOD_DSP_SetInputMix.FMod_DSP_SetInputMix_Prototype
   FMOD_DSP_SetInputMix = GetFunction(fmodLib, "FMOD_DSP_SetInputMix")
   
   ;- FMOD_DSP_GetInputMix_
   Prototype.l FMOD_DSP_GetInputMix_Prototype (Dsp.l, Index.l, Volume.f)
   Global FMOD_DSP_GetInputMix.FMod_DSP_GetInputMix_Prototype
   FMOD_DSP_GetInputMix = GetFunction(fmodLib, "FMOD_DSP_GetInputMix")
   
   ;- FMOD_DSP_SetInputLevels_
   Prototype.l FMOD_DSP_SetInputLevels_Prototype (Dsp.l, Index.l, Speaker.l, *Levels.Float, Numlevels.l)
   Global FMOD_DSP_SetInputLevels.FMod_DSP_SetInputLevels_Prototype
   FMOD_DSP_SetInputLevels = GetFunction(fmodLib, "FMOD_DSP_SetInputLevels")
   
   ;- FMOD_DSP_GetInputLevels_
   Prototype.l FMOD_DSP_GetInputLevels_Prototype (Dsp.l, Index.l, Speaker.l, *Levels.Float, Numlevels.l)
   Global FMOD_DSP_GetInputLevels.FMod_DSP_GetInputLevels_Prototype
   FMOD_DSP_GetInputLevels = GetFunction(fmodLib, "FMOD_DSP_GetInputLevels")
   
   ;- FMOD_DSP_SetOutputMix_
   Prototype.l FMOD_DSP_SetOutputMix_Prototype (Dsp.l, Index.l, Volume.f)
   Global FMOD_DSP_SetOutputMix.FMod_DSP_SetOutputMix_Prototype
   FMOD_DSP_SetOutputMix = GetFunction(fmodLib, "FMOD_DSP_SetOutputMix")
   
   ;- FMOD_DSP_GetOutputMix_
   Prototype.l FMOD_DSP_GetOutputMix_Prototype (Dsp.l, Index.l, Volume.f)
   Global FMOD_DSP_GetOutputMix.FMod_DSP_GetOutputMix_Prototype
   FMOD_DSP_GetOutputMix = GetFunction(fmodLib, "FMOD_DSP_GetOutputMix")
   
   ;- FMOD_DSP_SetOutputLevels_
   Prototype.l FMOD_DSP_SetOutputLevels_Prototype (Dsp.l, Index.l, Speaker.l, *Levels.Float, Numlevels.l)
   Global FMOD_DSP_SetOutputLevels.FMod_DSP_SetOutputLevels_Prototype
   FMOD_DSP_SetOutputLevels = GetFunction(fmodLib, "FMOD_DSP_SetOutputLevels")
   
   ;- FMOD_DSP_GetOutputLevels_
   Prototype.l FMOD_DSP_GetOutputLevels_Prototype (Dsp.l, Index.l, Speaker.l, *Levels.Float, Numlevels.l)
   Global FMOD_DSP_GetOutputLevels.FMod_DSP_GetOutputLevels_Prototype
   FMOD_DSP_GetOutputLevels = GetFunction(fmodLib, "FMOD_DSP_GetOutputLevels")
   
   ;- FMOD_DSP_SetActive_
   Prototype.l FMOD_DSP_SetActive_Prototype (Dsp.l, Active.l)
   Global FMOD_DSP_SetActive.FMod_DSP_SetActive_Prototype
   FMOD_DSP_SetActive = GetFunction(fmodLib, "FMOD_DSP_SetActive")
   
   ;- FMOD_DSP_GetActive_
   Prototype.l FMOD_DSP_GetActive_Prototype (Dsp.l, *Active.Long)
   Global FMOD_DSP_GetActive.FMod_DSP_GetActive_Prototype
   FMOD_DSP_GetActive = GetFunction(fmodLib, "FMOD_DSP_GetActive")
   
   ;- FMOD_DSP_SetBypass_
   Prototype.l FMOD_DSP_SetBypass_Prototype (Dsp.l, Bypass.l)
   Global FMOD_DSP_SetBypass.FMod_DSP_SetBypass_Prototype
   FMOD_DSP_SetBypass = GetFunction(fmodLib, "FMOD_DSP_SetBypass")
   
   ;- FMOD_DSP_GetBypass_
   Prototype.l FMOD_DSP_GetBypass_Prototype (Dsp.l, *Bypass.Long)
   Global FMOD_DSP_GetBypass.FMod_DSP_GetBypass_Prototype
   FMOD_DSP_GetBypass = GetFunction(fmodLib, "FMOD_DSP_GetBypass")
   
   ;- FMOD_DSP_Reset_
   Prototype.l FMOD_DSP_Reset_Prototype (Dsp.l)
   Global FMOD_DSP_Reset.FMod_DSP_Reset_Prototype
   FMOD_DSP_Reset = GetFunction(fmodLib, "FMOD_DSP_Reset")
   
   ;- FMOD_DSP_SetParameter_
   Prototype.l FMOD_DSP_SetParameter_Prototype (Dsp.l, Index.l, Value.f)
   Global FMOD_DSP_SetParameter.FMod_DSP_SetParameter_Prototype
   FMOD_DSP_SetParameter = GetFunction(fmodLib, "FMOD_DSP_SetParameter")
   
   ;- FMOD_DSP_GetParameter_
   Prototype.l FMOD_DSP_GetParameter_Prototype (Dsp.l, Index.l, *Value.Float, *Valuestr.Byte, Valuestrlen.l)
   Global FMOD_DSP_GetParameter.FMod_DSP_GetParameter_Prototype
   FMOD_DSP_GetParameter = GetFunction(fmodLib, "FMOD_DSP_GetParameter")
   
   ;- FMOD_DSP_GetNumParameters_
   Prototype.l FMOD_DSP_GetNumParameters_Prototype (Dsp.l, *Numparams.Long)
   Global FMOD_DSP_GetNumParameters.FMod_DSP_GetNumParameters_Prototype
   FMOD_DSP_GetNumParameters = GetFunction(fmodLib, "FMOD_DSP_GetNumParameters")
   
   ;- FMOD_DSP_GetParameterInfo_
   Prototype.l FMOD_DSP_GetParameterInfo_Prototype (Dsp.l, Index.l, *name.Byte, *label.Byte, *description.Byte, Descriptionlen.l, *min.Float, *max.Float)
   Global FMOD_DSP_GetParameterInfo.FMod_DSP_GetParameterInfo_Prototype
   FMOD_DSP_GetParameterInfo = GetFunction(fmodLib, "FMOD_DSP_GetParameterInfo")
   
   ;- FMOD_DSP_ShowConfigDialog_
   Prototype.l FMOD_DSP_ShowConfigDialog_Prototype (Dsp.l, hwnd.l, Show.l)
   Global FMOD_DSP_ShowConfigDialog.FMod_DSP_ShowConfigDialog_Prototype
   FMOD_DSP_ShowConfigDialog = GetFunction(fmodLib, "FMOD_DSP_ShowConfigDialog")
   
   ;- FMOD_DSP_GetInfo_
   Prototype.l FMOD_DSP_GetInfo_Prototype (Dsp.l, *name.Byte, *version.Long, *Channels.Long, *Configwidth.Long, *Configheight.Long)
   Global FMOD_DSP_GetInfo.FMod_DSP_GetInfo_Prototype
   FMOD_DSP_GetInfo = GetFunction(fmodLib, "FMOD_DSP_GetInfo")
   
   ;- FMOD_DSP_SetDefaults_
   Prototype.l FMOD_DSP_SetDefaults_Prototype (Dsp.l, Frequency.f, Volume.f, Pan.f, Priority.l)
   Global FMOD_DSP_SetDefaults.FMod_DSP_SetDefaults_Prototype
   FMOD_DSP_SetDefaults = GetFunction(fmodLib, "FMOD_DSP_SetDefaults")
   
   ;- FMOD_DSP_GetDefaults_
   Prototype.l FMOD_DSP_GetDefaults_Prototype (Dsp.l, *Frequency.Float, *Volume.Float, *Pan.Float, *Priority.Long)
   Global FMOD_DSP_GetDefaults.FMod_DSP_GetDefaults_Prototype
   FMOD_DSP_GetDefaults = GetFunction(fmodLib, "FMOD_DSP_GetDefaults")
   
   ;- FMOD_DSP_SetUserData_
   Prototype.l FMOD_DSP_SetUserData_Prototype (Dsp.l, userdata.l)
   Global FMOD_DSP_SetUserData.FMod_DSP_SetUserData_Prototype
   FMOD_DSP_SetUserData = GetFunction(fmodLib, "FMOD_DSP_SetUserData")
   
   ;- FMOD_DSP_GetUserData_
   Prototype.l FMOD_DSP_GetUserData_Prototype (Dsp.l, *userdata.Long)
   Global FMOD_DSP_GetUserData.FMod_DSP_GetUserData_Prototype
   FMOD_DSP_GetUserData = GetFunction(fmodLib, "FMOD_DSP_GetUserData")
   
   ;- FMOD_Geometry_Release_
   Prototype.l FMOD_Geometry_Release_Prototype (Geometry.l)
   Global FMOD_Geometry_Release.FMod_Geometry_Release_Prototype
   FMOD_Geometry_Release = GetFunction(fmodLib, "FMOD_Geometry_Release")
   
   ;- FMOD_Geometry_AddPolygon_
   Prototype.l FMOD_Geometry_AddPolygon_Prototype (Geometry.l, DirectOcclusion.f, ReverbOcclusion.f, DoubleSided.l, NumVertices.l, *Vertices.Long, *PolygonIndex.Long)
   Global FMOD_Geometry_AddPolygon.FMod_Geometry_AddPolygon_Prototype
   FMOD_Geometry_AddPolygon = GetFunction(fmodLib, "FMOD_Geometry_AddPolygon")
   
   ;- FMOD_Geometry_GetNumPolygons_
   Prototype.l FMOD_Geometry_GetNumPolygons_Prototype (Geometry.l, *NumPolygons.Long)
   Global FMOD_Geometry_GetNumPolygons.FMod_Geometry_GetNumPolygons_Prototype
   FMOD_Geometry_GetNumPolygons = GetFunction(fmodLib, "FMOD_Geometry_GetNumPolygons")
   
   ;- FMOD_Geometry_GetMaxPolygons_
   Prototype.l FMOD_Geometry_GetMaxPolygons_Prototype (Geometry.l, *MaxPolygons.Long, *MaxVertices.Long)
   Global FMOD_Geometry_GetMaxPolygons.FMod_Geometry_GetMaxPolygons_Prototype
   FMOD_Geometry_GetMaxPolygons = GetFunction(fmodLib, "FMOD_Geometry_GetMaxPolygons")
   
   ;- FMOD_Geometry_GetPolygonNumVertices_
   Prototype.l FMOD_Geometry_GetPolygonNumVertices_Prototype (Geometry.l, PolygonIndex.l, *NumVertices.Long)
   Global FMOD_Geometry_GetPolygonNumVertices.FMod_Geometry_GetPolygonNumVertices_Prototype
   FMOD_Geometry_GetPolygonNumVertices = GetFunction(fmodLib, "FMOD_Geometry_GetPolygonNumVertices")
   
   ;- FMOD_Geometry_SetPolygonVertex_
   Prototype.l FMOD_Geometry_SetPolygonVertex_Prototype (Geometry.l, PolygonIndex.l, VertexIndex.l, *Vertex.Long)
   Global FMOD_Geometry_SetPolygonVertex.FMod_Geometry_SetPolygonVertex_Prototype
   FMOD_Geometry_SetPolygonVertex = GetFunction(fmodLib, "FMOD_Geometry_SetPolygonVertex")
   
   ;- FMOD_Geometry_GetPolygonVertex_
   Prototype.l FMOD_Geometry_GetPolygonVertex_Prototype (Geometry.l, PolygonIndex.l, VertexIndex.l, *Vertex.Long)
   Global FMOD_Geometry_GetPolygonVertex.FMod_Geometry_GetPolygonVertex_Prototype
   FMOD_Geometry_GetPolygonVertex = GetFunction(fmodLib, "FMOD_Geometry_GetPolygonVertex")
   
   ;- FMOD_Geometry_SetPolygonAttributes_
   Prototype.l FMOD_Geometry_SetPolygonAttributes_Prototype (Geometry.l, PolygonIndex.l, DirectOcclusion.f, ReverbOcclusion.f, DoubleSided.l)
   Global FMOD_Geometry_SetPolygonAttributes.FMod_Geometry_SetPolygonAttributes_Prototype
   FMOD_Geometry_SetPolygonAttributes = GetFunction(fmodLib, "FMOD_Geometry_SetPolygonAttributes")
   
   ;- FMOD_Geometry_GetPolygonAttributes_
   Prototype.l FMOD_Geometry_GetPolygonAttributes_Prototype (Geometry.l, PolygonIndex.l, *DirectOcclusion.Float, *ReverbOcclusion.Float, *DoubleSided.Long)
   Global FMOD_Geometry_GetPolygonAttributes.FMod_Geometry_GetPolygonAttributes_Prototype
   FMOD_Geometry_GetPolygonAttributes = GetFunction(fmodLib, "FMOD_Geometry_GetPolygonAttributes")
   
   ;- FMOD_Geometry_SetActive_
   Prototype.l FMOD_Geometry_SetActive_Prototype (Geometry.l, Active.l)
   Global FMOD_Geometry_SetActive.FMod_Geometry_SetActive_Prototype
   FMOD_Geometry_SetActive = GetFunction(fmodLib, "FMOD_Geometry_SetActive")
   
   ;- FMOD_Geometry_GetActive_
   Prototype.l FMOD_Geometry_GetActive_Prototype (Geometry.l, *Active.Long)
   Global FMOD_Geometry_GetActive.FMod_Geometry_GetActive_Prototype
   FMOD_Geometry_GetActive = GetFunction(fmodLib, "FMOD_Geometry_GetActive")
   
   ;- FMOD_Geometry_SetRotation_
   Prototype.l FMOD_Geometry_SetRotation_Prototype (Geometry.l, *Forward.Long, *Up.Long)
   Global FMOD_Geometry_SetRotation.FMod_Geometry_SetRotation_Prototype
   FMOD_Geometry_SetRotation = GetFunction(fmodLib, "FMOD_Geometry_SetRotation")
   
   ;- FMOD_Geometry_GetRotation_
   Prototype.l FMOD_Geometry_GetRotation_Prototype (Geometry.l, *Forward.Long, *Up.Long)
   Global FMOD_Geometry_GetRotation.FMod_Geometry_GetRotation_Prototype
   FMOD_Geometry_GetRotation = GetFunction(fmodLib, "FMOD_Geometry_GetRotation")
   
   ;- FMOD_Geometry_SetPosition_
   Prototype.l FMOD_Geometry_SetPosition_Prototype (Geometry.l, *Position.Long)
   Global FMOD_Geometry_SetPosition.FMod_Geometry_SetPosition_Prototype
   FMOD_Geometry_SetPosition = GetFunction(fmodLib, "FMOD_Geometry_SetPosition")
   
   ;- FMOD_Geometry_GetPosition_
   Prototype.l FMOD_Geometry_GetPosition_Prototype (Geometry.l, *Position.Long)
   Global FMOD_Geometry_GetPosition.FMod_Geometry_GetPosition_Prototype
   FMOD_Geometry_GetPosition = GetFunction(fmodLib, "FMOD_Geometry_GetPosition")
   
   ;- FMOD_Geometry_SetScale_
   Prototype.l FMOD_Geometry_SetScale_Prototype (Geometry.l, *Scale.Long)
   Global FMOD_Geometry_SetScale.FMod_Geometry_SetScale_Prototype
   FMOD_Geometry_SetScale = GetFunction(fmodLib, "FMOD_Geometry_SetScale")
   
   ;- FMOD_Geometry_GetScale_
   Prototype.l FMOD_Geometry_GetScale_Prototype (Geometry.l, *Scale.Long)
   Global FMOD_Geometry_GetScale.FMod_Geometry_GetScale_Prototype
   FMOD_Geometry_GetScale = GetFunction(fmodLib, "FMOD_Geometry_GetScale")
   
   ;- FMOD_Geometry_Save_
   Prototype.l FMOD_Geometry_Save_Prototype (Geometry.l, _data.l, *_dataSize.Long)
   Global FMOD_Geometry_Save.FMod_Geometry_Save_Prototype
   FMOD_Geometry_Save = GetFunction(fmodLib, "FMOD_Geometry_Save")
   
   ;- FMOD_Geometry_SetUserData_
   Prototype.l FMOD_Geometry_SetUserData_Prototype (Geometry.l, userdata.l)
   Global FMOD_Geometry_SetUserData.FMod_Geometry_SetUserData_Prototype
   FMOD_Geometry_SetUserData = GetFunction(fmodLib, "FMOD_Geometry_SetUserData")
   
   ;- FMOD_Geometry_GetUserData_
   Prototype.l FMOD_Geometry_GetUserData_Prototype (Geometry.l, *userdata.Long)
   Global FMOD_Geometry_GetUserData.FMod_Geometry_GetUserData_Prototype
   FMOD_Geometry_GetUserData = GetFunction(fmodLib, "FMOD_Geometry_GetUserData")

;-#############################
;-############################# from fmod_errors
;-#############################

Procedure.s FMOD_ErrorString(errcode.l)
  Protected FMOD_ErrorString.s
  
  Select errcode
    Case #FMOD_OK:                         FMOD_ErrorString = "No errors."
    Case #FMOD_ERR_ALREADYLOCKED:          FMOD_ErrorString = "Tried to call lock a second time before unlock was called. "
    Case #FMOD_ERR_BADCOMMAND:             FMOD_ErrorString = "Tried to call a function on a data type that does not allow this type of functionality (ie calling Sound::lock on a streaming sound). "
    Case #FMOD_ERR_CDDA_DRIVERS:           FMOD_ErrorString = "Neither NTSCSI nor ASPI could be initialised. "
    Case #FMOD_ERR_CDDA_INIT:              FMOD_ErrorString = "An error occurred while initialising the CDDA subsystem. "
    Case #FMOD_ERR_CDDA_INVALID_DEVICE:    FMOD_ErrorString = "Couldn;t find the specified device. "
    Case #FMOD_ERR_CDDA_NOAUDIO:           FMOD_ErrorString = "No audio tracks on the specified disc. "
    Case #FMOD_ERR_CDDA_NODEVICES:         FMOD_ErrorString = "No CD/DVD devices were found. "
    Case #FMOD_ERR_CDDA_NODISC:            FMOD_ErrorString = "No disc present in the specified drive. "
    Case #FMOD_ERR_CDDA_READ:              FMOD_ErrorString = "A CDDA read error occurred. "
    Case #FMOD_ERR_CHANNEL_ALLOC:          FMOD_ErrorString = "Error trying to allocate a channel. "
    Case #FMOD_ERR_CHANNEL_STOLEN:         FMOD_ErrorString = "The specified channel has been reused to play another sound. "
    Case #FMOD_ERR_COM:                    FMOD_ErrorString = "A Win32 COM related error occured. COM failed to initialize or a QueryInterface failed meaning a Windows codec or driver was not installed properly. "
    Case #FMOD_ERR_DMA:                    FMOD_ErrorString = "DMA Failure.  See debug output for more information. "
    Case #FMOD_ERR_DSP_CONNECTION:         FMOD_ErrorString = "DSP connection error.  Connection possibly caused a cyclic dependancy. "
    Case #FMOD_ERR_DSP_FORMAT:             FMOD_ErrorString = "DSP Format error.  A DSP unit may have attempted to connect to this network with the wrong format. "
    Case #FMOD_ERR_DSP_NOTFOUND:           FMOD_ErrorString = "DSP connection error.  Couldn;t find the DSP unit specified. "
    Case #FMOD_ERR_DSP_RUNNING:            FMOD_ErrorString = "DSP error.  Cannot perform this operation while the network is in the middle of running.  This will most likely happen if a connection or disconnection is attempted in a DSP callback. "
    Case #FMOD_ERR_DSP_TOOMANYCONNECTIONS: FMOD_ErrorString = "DSP connection error.  The unit being connected to or disconnected should only have 1 input or output. "
    Case #FMOD_ERR_FILE_BAD:               FMOD_ErrorString = "Error loading file. "
    Case #FMOD_ERR_FILE_COULDNOTSEEK:      FMOD_ErrorString = "Couldn;t perform seek operation.  This is a limitation of the medium (ie netstreams) or the file format. "
    Case #FMOD_ERR_FILE_EOF:               FMOD_ErrorString = "End of file unexpectedly reached while trying to read essential data (truncated data?). "
    Case #FMOD_ERR_FILE_NOTFOUND:          FMOD_ErrorString = "File not found. "
    Case #FMOD_ERR_FILE_UNWANTED:          FMOD_ErrorString = "Unwanted file access occured."
    Case #FMOD_ERR_FORMAT:                 FMOD_ErrorString = "Unsupported file or audio format. "
    Case #FMOD_ERR_HTTP:                   FMOD_ErrorString = "A HTTP error occurred. This is a catch-all for HTTP errors not listed elsewhere. "
    Case #FMOD_ERR_HTTP_ACCESS:            FMOD_ErrorString = "The specified resource requires authentication or is forbidden. "
    Case #FMOD_ERR_HTTP_PROXY_AUTH:        FMOD_ErrorString = "Proxy authentication is required to access the specified resource. "
    Case #FMOD_ERR_HTTP_SERVER_ERROR:      FMOD_ErrorString = "A HTTP server error occurred. "
    Case #FMOD_ERR_HTTP_TIMEOUT:           FMOD_ErrorString = "The HTTP request timed out. "
    Case #FMOD_ERR_INITIALIZATION:         FMOD_ErrorString = "FMOD was not initialized correctly to support this function. "
    Case #FMOD_ERR_INITIALIZED:            FMOD_ErrorString = "Cannot call this command after System::init. "
    Case #FMOD_ERR_INTERNAL:               FMOD_ErrorString = "An error occured that wasnt supposed to.  Contact support. "
    Case #FMOD_ERR_INVALID_ADDRESS:        FMOD_ErrorString = "On Xbox 360, this memory address passed to FMOD must be physical, (ie allocated with XPhysicalAlloc.)"
    Case #FMOD_ERR_INVALID_FLOAT:          FMOD_ErrorString = "Value passed in was a NaN, Inf or denormalized float."
    Case #FMOD_ERR_INVALID_HANDLE:         FMOD_ErrorString = "An invalid object handle was used. "
    Case #FMOD_ERR_INVALID_PARAM:          FMOD_ErrorString = "An invalid parameter was passed to this function. "
    Case #FMOD_ERR_INVALID_SPEAKER:        FMOD_ErrorString = "An invalid speaker was passed to this function based on the current speaker mode. "
    Case #FMOD_ERR_INVALID_VECTOR:         FMOD_ErrorString = "The vectors passed in are not unit length, or perpendicular."
    Case #FMOD_ERR_IRX:                    FMOD_ErrorString = "PS2 only.  fmodex.irx failed to initialize.  This is most likely because you forgot to load it. "
    Case #FMOD_ERR_MEMORY:                 FMOD_ErrorString = "Not enough memory or resources. "
    Case #FMOD_ERR_MEMORY_IOP:             FMOD_ErrorString = "PS2 only.  Not enough memory or resources on PlayStation 2 IOP ram. "
    Case #FMOD_ERR_MEMORY_SRAM:            FMOD_ErrorString = "Not enough memory or resources on console sound ram. "
    Case #FMOD_ERR_MEMORY_CANTPOINT:       FMOD_ErrorString = "Can;t use FMOD_OPENMEMORY_POINT on non PCM source data, or non mp3/xma/adpcm data if FMOD_CREATECOMPRESSEDSAMPLE was used."
    Case #FMOD_ERR_NEEDS2D:                FMOD_ErrorString = "Tried to call a command on a 3d sound when the command was meant for 2d sound. "
    Case #FMOD_ERR_NEEDS3D:                FMOD_ErrorString = "Tried to call a command on a 2d sound when the command was meant for 3d sound. "
    Case #FMOD_ERR_NEEDSHARDWARE:          FMOD_ErrorString = "Tried to use a feature that requires hardware support.  (ie trying to play a VAG compressed sound in software on PS2). "
    Case #FMOD_ERR_NEEDSSOFTWARE:          FMOD_ErrorString = "Tried to use a feature that requires the software engine.  Software engine has either been turned off, or command was executed on a hardware channel which does not support this feature. "
    Case #FMOD_ERR_NET_CONNECT:            FMOD_ErrorString = "Couldn;t connect to the specified host. "
    Case #FMOD_ERR_NET_SOCKET_ERROR:       FMOD_ErrorString = "A socket error occurred.  This is a catch-all for socket-related errors not listed elsewhere. "
    Case #FMOD_ERR_NET_URL:                FMOD_ErrorString = "The specified URL couldn;t be resolved. "
    Case #FMOD_ERR_NOTREADY:               FMOD_ErrorString = "Operation could not be performed because specified sound is not ready. "
    Case #FMOD_ERR_OUTPUT_ALLOCATED:       FMOD_ErrorString = "Error initializing output device, but more specifically, the output device is already in use and cannot be reused. "
    Case #FMOD_ERR_OUTPUT_CREATEBUFFER:    FMOD_ErrorString = "Error creating hardware sound buffer. "
    Case #FMOD_ERR_OUTPUT_DRIVERCALL:      FMOD_ErrorString = "A call to a standard soundcard driver failed, which could possibly mean a bug in the driver or resources were missing or exhausted. "
    Case #FMOD_ERR_OUTPUT_FORMAT:          FMOD_ErrorString = "Soundcard does not support the minimum features needed for this soundsystem (16bit stereo output). "
    Case #FMOD_ERR_OUTPUT_INIT:            FMOD_ErrorString = "Error initializing output device. "
    Case #FMOD_ERR_OUTPUT_NOHARDWARE:      FMOD_ErrorString = "FMOD_HARDWARE was specified but the sound card does not have the resources nescessary to play it. "
    Case #FMOD_ERR_OUTPUT_NOSOFTWARE:      FMOD_ErrorString = "Attempted to create a software sound but no software channels were specified in System::init. "
    Case #FMOD_ERR_PAN:                    FMOD_ErrorString = "Panning only works with mono or stereo sound sources. "
    Case #FMOD_ERR_PLUGIN:                 FMOD_ErrorString = "An unspecified error has been  = ed from a 3rd party plugin. "
    Case #FMOD_ERR_PLUGIN_MISSING:         FMOD_ErrorString = "A requested output, dsp unit type or codec was not available. "
    Case #FMOD_ERR_PLUGIN_RESOURCE:        FMOD_ErrorString = "A resource that the plugin requires cannot be found. (ie the DLS file for MIDI playback) "
    Case #FMOD_ERR_RECORD:                 FMOD_ErrorString = "An error occured trying to initialize the recording device. "
    Case #FMOD_ERR_REVERB_INSTANCE:        FMOD_ErrorString = "Specified Instance in FMOD_REVERB_PROPERTIES couldn;t be set. Most likely because another application has locked the EAX4 FX slot. "
    Case #FMOD_ERR_SUBSOUNDS:              FMOD_ErrorString = "The error occured because the sound referenced contains subsounds.  (ie you cannot play the parent sound as a static sample, only its subsounds.) "
    Case #FMOD_ERR_SUBSOUND_ALLOCATED:     FMOD_ErrorString = "This subsound is already being used by another sound, you cannot have more than one parent to a sound.  Null out the other parent;s entry first. "
    Case #FMOD_ERR_TAGNOTFOUND:            FMOD_ErrorString = "The specified tag could not be found or there are no tags. "
    Case #FMOD_ERR_TOOMANYCHANNELS:        FMOD_ErrorString = "The sound created exceeds the allowable input channel count.  This can be increased using the maxinputchannels parameter in System::setSoftwareFormat."
    Case #FMOD_ERR_UNIMPLEMENTED:          FMOD_ErrorString = "Something in FMOD hasn;t been implemented when it should be! contact support! "
    Case #FMOD_ERR_UNINITIALIZED:          FMOD_ErrorString = "This command failed because System::init or System::setDriver was not called. "
    Case #FMOD_ERR_UNSUPPORTED:            FMOD_ErrorString = "A command issued was not supported by this object.  Possibly a plugin without certain callbacks specified. "
    Case #FMOD_ERR_UPDATE:                 FMOD_ErrorString = "On PS2, System::update was called twice in a row when System::updateFinished must be called first. "
    Case #FMOD_ERR_VERSION:                FMOD_ErrorString = "The version number of this file format is not supported. "
    Case #FMOD_ERR_EVENT_FAILED:           FMOD_ErrorString = "An Event failed to be retrieved, most likely due to ;just fail' being specified as the max playbacks behaviour."
    Case #FMOD_ERR_EVENT_INTERNAL:         FMOD_ErrorString = "An error occured that wasn;t supposed to.  See debug log for reason."
    Case #FMOD_ERR_EVENT_NAMECONFLICT:     FMOD_ErrorString = "A category with the same name already exists."
    Case #FMOD_ERR_EVENT_NOTFOUND:         FMOD_ErrorString = "The requested event, event group, event category or event property could not be found."
    Default:                               FMOD_ErrorString = "Unknown error."
  EndSelect
  
  ProcedureReturn FMOD_ErrorString
EndProcedure
  
; jaPBe Version=2.5.2.24
; Build=0
; FirstLine=0
; CursorPosition=3
; ExecutableFormat=Windows
; DontSaveDeclare
; IDE Options = PureBasic 5.10 Beta 5 (Windows - x86)
; Folding = -
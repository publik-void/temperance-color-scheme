using ColorSchemeExporter
using Colors
using Dictionaries

# This will be the background color for the standard lightwarm scheme. The main
# requirement for this one is to tilt the light spectrum of the screen away from
# blue and emphasize red while maintaining adequate luminance for a light
# background color relative to the screen's backlight. Thus, let's define this
# starting point in RGB, because it allows to directly control the mix of the 3
# color bands.
base_lightwarm_rgb = RGB(1., .915, .78)

# Overall luminance offset for dark schemes
luminance_dark_background_light_foreground_offset = -6.

# The distance of the dark fore-/background from light back-/foreground
base_luminance_span  = 75.

# To reduce the contrast between foreground and background
foreground_luminance_light_muting = .35
foreground_luminance_dark_muting = .3
foreground_chroma_muting = .7

# "Grayed out" color stands in for black or white depending on background
gray_luminance_muting = .65
gray_chroma_muting = .65

# As above, stands in for bright black or bright white depending on background
verygray_luminance_muting = .85
verygray_chroma_muting = .3

# For black and bright white, use a luminance offset from bright black and white
black_luminance_offset = -30.
bright_white_luminance_offset = 15.

# Background luminance adjustments – to taste, as long as they're small
background_luminance_lightwarm_offset = 0.
background_luminance_darkwarm_offset  = -3.
background_luminance_lightcold_offset = 4.
background_luminance_darkcold_offset  = 0.

# Foreground luminance adjustments – to taste, as long as they're small
foreground_luminance_lightwarm_offset = 0.
foreground_luminance_darkwarm_offset  = -1.
foreground_luminance_lightcold_offset = 4.
foreground_luminance_darkcold_offset  = 0.

# Hue adjustments – to taste but maybe not too big
base_hue_lightwarm_offset =  0.
base_hue_darkwarm_offset = -40.
base_hue_lightcold_offset = 20.
base_hue_darkcold_offset = -35.

# Huecolors – the requirements here would be to keep these mostly isoluminant
# and equally spaced across the hue circle while having them resemble the colors
# they are named after.
huecolor_luminance = 55.
huecolor_bright_luminance = 80.
huecolor_chroma = 80.
huecolor_bright_chroma = 110.
huecolor_hue_offset = 25.

huecolor_luminance_offsets =
  dictionary((:red => -15., :blue => -17., :magenta => -10., :cyan => -2.))
huecolor_bright_luminance_offsets =
  dictionary((:red => 15., :magenta => 5., :blue => -5., :cyan => -3.))
huecolor_chroma_offsets =
  dictionary((:red => 7.5, :yellow => 5., :cyan => 10.))
huecolor_hue_offsets =
  dictionary((:red => 7.5, :cyan => -7.5, :blue => 10., :yellow => -5.))

# Shades of Gray for the high contrast schemes
high_contrast_shade_luminances = [0., 20., 40., 60., 80., 100.]

# For iTerm2, completeness, distiguishability, whatever…
badge_alpha = .5

# Calculate some intermediates from the starting points
base_lightwarm_lchab = convert(LCHab, base_lightwarm_rgb)

base_luminance_light = base_lightwarm_lchab.l
base_luminance_dark = base_luminance_light - base_luminance_span

base_chroma = base_lightwarm_lchab.c

base_hue_warm = base_lightwarm_lchab.h
base_hue_cold = base_hue_warm + 180.
base_hue_lightwarm = base_hue_warm + base_hue_lightwarm_offset
base_hue_darkwarm = base_hue_warm + base_hue_darkwarm_offset
base_hue_lightcold = base_hue_cold + base_hue_lightcold_offset
base_hue_darkcold = base_hue_cold + base_hue_darkcold_offset

background_luminance_lightwarm =
  base_luminance_light + background_luminance_lightwarm_offset
background_luminance_darkwarm =
  base_luminance_dark + background_luminance_darkwarm_offset +
  luminance_dark_background_light_foreground_offset
background_luminance_lightcold =
  base_luminance_light + background_luminance_lightcold_offset
background_luminance_darkcold =
  base_luminance_dark + background_luminance_darkcold_offset +
  luminance_dark_background_light_foreground_offset

foreground_luminance_dark =
  base_luminance_dark + foreground_luminance_dark_muting * base_luminance_span
foreground_luminance_darkwarm =
  foreground_luminance_dark + foreground_luminance_darkwarm_offset
foreground_luminance_darkcold =
  foreground_luminance_dark + foreground_luminance_darkcold_offset

foreground_luminance_light = luminance_dark_background_light_foreground_offset +
  base_luminance_light - foreground_luminance_light_muting * base_luminance_span
foreground_luminance_lightwarm =
  foreground_luminance_light + foreground_luminance_lightwarm_offset
foreground_luminance_lightcold =
  foreground_luminance_light + foreground_luminance_lightcold_offset

foreground_chroma = base_chroma * (1. - foreground_chroma_muting)

gray_luminance_dark =
  base_luminance_dark + (1. - gray_luminance_muting) * base_luminance_span
gray_luminance_light =
  base_luminance_light - (1. - gray_luminance_muting) * base_luminance_span
gray_chroma = base_chroma * (1. - gray_chroma_muting)

verygray_luminance_dark =
  base_luminance_dark + (1. - verygray_luminance_muting) * base_luminance_span
verygray_luminance_light =
  base_luminance_light - (1. - verygray_luminance_muting) * base_luminance_span
verygray_chroma = base_chroma * (1. - verygray_chroma_muting)

cs_background_darkwarm  =
  LCHab(background_luminance_darkwarm , base_chroma, base_hue_darkwarm)
cs_background_darkcold  =
  LCHab(background_luminance_darkcold , base_chroma, base_hue_darkcold)
cs_background_lightwarm =
  LCHab(background_luminance_lightwarm, base_chroma, base_hue_lightwarm)
cs_background_lightcold =
  LCHab(background_luminance_lightcold, base_chroma, base_hue_lightcold)

cs_foreground_darkwarm  =
  LCHab(foreground_luminance_darkwarm , foreground_chroma, base_hue_darkwarm)
cs_foreground_darkcold  =
  LCHab(foreground_luminance_darkcold , foreground_chroma, base_hue_darkcold)
cs_foreground_lightwarm =
  LCHab(foreground_luminance_lightwarm, foreground_chroma, base_hue_lightwarm)
cs_foreground_lightcold =
  LCHab(foreground_luminance_lightcold, foreground_chroma, base_hue_lightcold)

cs_gray_darkwarm  =
  LCHab(gray_luminance_dark , gray_chroma, base_hue_darkwarm)
cs_gray_darkcold  =
  LCHab(gray_luminance_dark , gray_chroma, base_hue_darkcold)
cs_gray_lightwarm =
  LCHab(gray_luminance_light, gray_chroma, base_hue_lightwarm)
cs_gray_lightcold =
  LCHab(gray_luminance_light, gray_chroma, base_hue_lightcold)

cs_verygray_darkwarm  =
  LCHab(verygray_luminance_dark , verygray_chroma, base_hue_darkwarm)
cs_verygray_darkcold  =
  LCHab(verygray_luminance_dark , verygray_chroma, base_hue_darkcold)
cs_verygray_lightwarm =
  LCHab(verygray_luminance_light, verygray_chroma, base_hue_lightwarm)
cs_verygray_lightcold =
  LCHab(verygray_luminance_light, verygray_chroma, base_hue_lightcold)

offset_luminance(c::LCHab, offset) = LCHab(c.l + offset, c.c, c.h)
cs_background_darkwarm_dark =
  offset_luminance(cs_background_darkwarm, black_luminance_offset)
cs_background_darkcold_dark =
  offset_luminance(cs_background_darkcold, black_luminance_offset)
cs_background_lightwarm_light =
  offset_luminance(cs_background_lightwarm, bright_white_luminance_offset)
cs_background_lightcold_light =
  offset_luminance(cs_background_lightcold, bright_white_luminance_offset)

cs_ansi_huecolors = [
  c => LCHab(
    huecolor_luminance + get(huecolor_luminance_offsets, c, 0.),
    huecolor_chroma + get(huecolor_chroma_offsets, c, 0.),
    ansi_base_hues[c] + huecolor_hue_offset + get(huecolor_hue_offsets, c, 0.))
  for c in ansi_huecolors]

cs_ansi_huecolors_bright = [
  brightname(c) => LCHab(
    huecolor_bright_luminance + get(huecolor_luminance_offsets, c, 0.) +
                                get(huecolor_bright_luminance_offsets, c, 0.),
    huecolor_bright_chroma,
    ansi_base_hues[c] + huecolor_hue_offset + get(huecolor_hue_offsets, c, 0.))
  for c in ansi_huecolors]

as_rgba(pairs::Pair{Symbol, <:Colorant}...) = map(pairs) do pair
    pair.first => RGBA(pair.second)
  end

as_rgb(pairs::Pair{Symbol, <:Colorant}...) = map(pairs) do pair
    pair.first => RGB(pair.second)
  end

cdict(pairs::Pair{Symbol, <:Colorant}...) =
  Dictionary{Symbol, Colorant}((pair.first for pair in pairs),
                               (pair.second for pair in pairs))
cdict(pairs::NTuple{<:Any, <:Pair{Symbol, <:Colorant}}) = cdict(pairs...)

create_high_contrast_shades(names...) =
  map(zip(names, sort(high_contrast_shade_luminances))) do (name, l)
    name => LCHab(l, 0., 0.)
  end

function add_extra_colors!(d)
  insert!(d, :badge, RGBA(RGB(d[:foreground]), badge_alpha))
end

# Create color dictionaries
cslw = cdict(as_rgb(
  :background => cs_background_lightwarm,
  :foreground => cs_foreground_darkcold,
  :black => cs_background_darkcold_dark,
  :white => cs_gray_lightwarm,
  :bright_black => cs_background_darkcold,
  :bright_white => cs_verygray_lightwarm,
  cs_ansi_huecolors..., cs_ansi_huecolors_bright...))

csdw = cdict(as_rgb(
  :background => cs_background_darkwarm,
  :foreground => cs_foreground_lightcold,
  :black => cs_gray_darkwarm,
  :white => cs_background_lightcold_light,
  :bright_black => cs_verygray_darkwarm,
  :bright_white => cs_background_lightcold,
  cs_ansi_huecolors..., cs_ansi_huecolors_bright...))

cslc = cdict(as_rgb(
  :background => cs_background_lightcold,
  :foreground => cs_foreground_darkwarm,
  :black => cs_background_darkwarm_dark,
  :white => cs_gray_lightcold,
  :bright_black => cs_background_darkwarm,
  :bright_white => cs_verygray_lightcold,
  cs_ansi_huecolors..., cs_ansi_huecolors_bright...))

csdc = cdict(as_rgb(
  :background => cs_background_darkcold,
  :foreground => cs_foreground_lightwarm,
  :black => cs_gray_darkcold,
  :white => cs_background_lightwarm_light,
  :bright_black => cs_verygray_darkcold,
  :bright_white => cs_background_lightwarm,
  cs_ansi_huecolors..., cs_ansi_huecolors_bright...))

cslh = cdict(as_rgb(create_high_contrast_shades(
    :foreground, :black, :bright_black, :white, :bright_white, :background)...,
  cs_ansi_huecolors..., cs_ansi_huecolors_bright...))

csdh = cdict(as_rgb(create_high_contrast_shades(
    :background, :black, :bright_black, :white, :bright_white, :foreground)...,
  cs_ansi_huecolors..., cs_ansi_huecolors_bright...))

cs = cslw, csdw, cslc, csdc, cslh, csdh

map(add_extra_colors!, cs)

write_files(
  "temperance-day"   => cslw,
  "temperance-dusk"  => csdw,
  "temperance-night" => csdc,
  "temperance-dawn"  => cslc,
  "untempered-light" => cslh,
  "untempered-dark"  => csdh;
  name = "temperance", out_dir = @__DIR__)

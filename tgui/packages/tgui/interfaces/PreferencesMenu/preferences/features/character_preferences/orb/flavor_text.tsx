/*
 * ORBSTATION: CHARACTER HEADSHOT
 * COPIED FROM SKYRAT
 */
import { Feature, FeatureTextInput, FeatureShortTextInput } from '../../base';

export const flavor_text: Feature<string> = {
  name: 'Flavor Text',
  description: 'Describe your character!',
  component: FeatureTextInput,
};

export const silicon_flavor_text: Feature<string> = {
  name: 'Flavor Text (Silicon)',
  description: 'Describe your cyborg!',
  component: FeatureTextInput,
};

export const flavor_text_short: Feature<string> = {
  name: 'Flavor Text (Short)',
  description: 'Describe your character, briefly!',
  component: FeatureShortTextInput,
};

export const silicon_flavor_text_short: Feature<string> = {
  name: 'Flavor Text (Silicon; Short)',
  description: 'Describe your cyborg, briefly!',
  component: FeatureShortTextInput,
};

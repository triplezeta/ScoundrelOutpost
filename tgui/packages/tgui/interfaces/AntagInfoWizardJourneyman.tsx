import { useBackend } from '../backend';
import { Section, Stack } from '../components';
import { BooleanLike } from 'common/react';
import { Window } from '../layouts';

const teleportstyle = {
  color: 'yellow',
};

const robestyle = {
  color: 'lightblue',
};

const destructionstyle = {
  color: 'red',
};

const defensestyle = {
  color: 'orange',
};

const summonstyle = {
  color: 'cyan',
};

const ritualstyle = {
  fontWeight: 'bold',
  color: '#bd54e0',
};

type Objective = {
  count: number;
  name: string;
  explanation: string;
  complete: BooleanLike;
  was_uncompleted: BooleanLike;
  reward: number;
};

type GrandRitual = {
  remaining: number;
  next_area: string;
};

type Info = {
  objectives: Objective[];
  ritual: GrandRitual;
};

export const AntagInfoWizardJourneyman = (props, context) => {
  return (
    <Window width={620} height={655} theme="wizard">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section>
              <Stack vertical>
                <Stack.Item textAlign="center" textColor="red" fontSize="20px">
                  You are the Space Wizard Journeyman!
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section fill title="Goals">
              <Stack vertical fill>
                <Stack.Item>
                  You have been recognised for your academic achievement, but do
                  not yet have the respect of your elders and there is only one
                  traditional way to impress the circle of Wizards.
                  <br />
                  <br />
                  Play an unforgettable prank on Nanotrasen.
                  <br />
                </Stack.Item>
                <Stack.Item>
                  <ObjectivePrintout />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section fill title="Diploma">
              <Stack vertical fill>
                <Stack.Item>
                  Your magical diploma will remind you what spells you majored
                  in during your studies. You get three choices from three
                  categories, each of which will present you with three options.
                  <br />
                  <span style={destructionstyle}>
                    The first category will present you with spells or artifacts
                    you can use to obliterate your enemies or their space
                    station.
                  </span>
                  <br />
                  <span style={defensestyle}>
                    The second category will present you with spells or
                    artifacts you can use to keep yourself safe and alive,
                    always important.
                  </span>
                  <br />
                  <span style={summonstyle}>
                    The final category contains spells and artifacts of less
                    straightforward utility, though they are no less valuable.
                  </span>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title="Misc Gear">
              <Stack>
                <Stack.Item>
                  <span style={teleportstyle}>Teleport scroll:</span> 4 uses to
                  teleport wherever you want. You will not be able to come back
                  to your den, so be sure you have everything ready before
                  departing.
                  <br />
                  <span style={robestyle}>Wizard robes:</span> Used to cast most
                  spells. Your diploma will let you know which spells cannot be
                  cast without a garb.
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section textAlign="center" textColor="red" fontSize="20px">
              Remember: Do not forget to prepare your spells.
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const ObjectivePrintout = (props, context) => {
  const { data } = useBackend<Info>(context);
  const { objectives, ritual } = data;
  return (
    <Stack vertical>
      <Stack.Item bold>
        The Space Wizards Federation would be impressed by the following tasks:
      </Stack.Item>
      <Stack.Item>
        {(!objectives && 'None!') ||
          objectives.map((objective) => (
            <Stack.Item key={objective.count}>
              #{objective.count}: {objective.explanation}
            </Stack.Item>
          ))}
      </Stack.Item>
      <Stack.Item>
        Alternately, complete the <span style={ritualstyle}>Grand Ritual </span>
        by invoking a ritual circle at several nexuses of power.
        <br />
        You must complete the ritual
        <span style={ritualstyle}> {ritual.remaining}</span> more times.
        <br />
        Your next ritual location is the
        <span style={ritualstyle}> {ritual.next_area}</span>.
      </Stack.Item>
    </Stack>
  );
};

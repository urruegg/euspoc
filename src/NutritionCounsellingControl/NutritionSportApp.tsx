import * as React from 'react';
import { Stack, Text } from '@fluentui/react';
import { FluentProvider, webLightTheme } from '@fluentui/react-components';
import { MetabolicInfoCard } from './components/MetabolicInfoCard';
import { mockMetabolicData } from './mocks/mockMetabolicData';
import { ActivityLevel, Gender } from './types/MetabolicData';

export interface INutritionSportAppProps {
    clientName?: string;
    onUpdate?: (data: string) => void;
}

export const NutritionSportApp: React.FC<INutritionSportAppProps> = (props) => {
    const [metabolicData, setMetabolicData] = React.useState(mockMetabolicData);

    const handleActivityChange = (activityLevel: ActivityLevel) => {
        setMetabolicData(prev => ({
            ...prev,
            activityLevel
        }));
        
        if (props.onUpdate) {
            props.onUpdate(JSON.stringify({ activityLevel }));
        }
    };

    const handleWeightChange = (weight: number) => {
        setMetabolicData(prev => ({
            ...prev,
            weight
        }));
        
        if (props.onUpdate) {
            props.onUpdate(JSON.stringify({ weight }));
        }
    };

    const handleGenderChange = (gender: Gender) => {
        setMetabolicData(prev => ({
            ...prev,
            gender
        }));
        
        if (props.onUpdate) {
            props.onUpdate(JSON.stringify({ gender }));
        }
    };

    return (
        <Stack tokens={{ childrenGap: 15, padding: 20 }} styles={{ root: { maxWidth: 800 } }}>
            <Text variant="xxLarge">Nutrition Counselling</Text>
            
            {props.clientName && (
                <Text variant="large">Klient: {props.clientName}</Text>
            )}

            {/* Fluent UI v9 components wrapped in FluentProvider */}
            <FluentProvider theme={webLightTheme}>
                <MetabolicInfoCard 
                    data={metabolicData} 
                    isLoading={false}
                    onActivityChange={handleActivityChange}
                    onWeightChange={handleWeightChange}
                    onGenderChange={handleGenderChange}
                />
            </FluentProvider>
        </Stack>
    );
};

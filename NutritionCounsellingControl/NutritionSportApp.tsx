import * as React from 'react';
import { Stack, Text, TextField, PrimaryButton, MessageBar, MessageBarType } from '@fluentui/react';

export interface INutritionSportAppProps {
    clientName?: string;
    onUpdate?: (data: string) => void;
}

export interface INutritionSportAppState {
    nutritionNotes: string;
    exerciseNotes: string;
    goals: string;
    showSuccess: boolean;
}

export class NutritionSportApp extends React.Component<INutritionSportAppProps, INutritionSportAppState> {
    constructor(props: INutritionSportAppProps) {
        super(props);
        this.state = {
            nutritionNotes: '',
            exerciseNotes: '',
            goals: '',
            showSuccess: false
        };
    }

    private onNutritionChange = (event: React.FormEvent<HTMLInputElement | HTMLTextAreaElement>, newValue?: string): void => {
        this.setState({ nutritionNotes: newValue || '' });
    };

    private onExerciseChange = (event: React.FormEvent<HTMLInputElement | HTMLTextAreaElement>, newValue?: string): void => {
        this.setState({ exerciseNotes: newValue || '' });
    };

    private onGoalsChange = (event: React.FormEvent<HTMLInputElement | HTMLTextAreaElement>, newValue?: string): void => {
        this.setState({ goals: newValue || '' });
    };

    private onSave = (): void => {
        const data = JSON.stringify({
            nutrition: this.state.nutritionNotes,
            exercise: this.state.exerciseNotes,
            goals: this.state.goals,
            timestamp: new Date().toISOString()
        });

        if (this.props.onUpdate) {
            this.props.onUpdate(data);
        }

        this.setState({ showSuccess: true });
        setTimeout(() => this.setState({ showSuccess: false }), 3000);
    };

    public render(): React.ReactElement {
        return (
            <Stack tokens={{ childrenGap: 15, padding: 20 }} styles={{ root: { maxWidth: 600 } }}>
                <Text variant="xxLarge">Ernährung & Sport Beratung</Text>
                
                {this.props.clientName && (
                    <Text variant="large">Klient: {this.props.clientName}</Text>
                )}

                {this.state.showSuccess && (
                    <MessageBar messageBarType={MessageBarType.success} isMultiline={false}>
                        Counselling notes saved successfully!
                    </MessageBar>
                )}

                <TextField
                    label="Ernährungsnotizen"
                    multiline
                    rows={4}
                    value={this.state.nutritionNotes}
                    onChange={this.onNutritionChange}
                    placeholder="Enter nutrition counselling notes..."
                />

                <TextField
                    label="Sportnotizen"
                    multiline
                    rows={4}
                    value={this.state.exerciseNotes}
                    onChange={this.onExerciseChange}
                    placeholder="Enter exercise counselling notes..."
                />

                <TextField
                    label="Ziele"
                    multiline
                    rows={3}
                    value={this.state.goals}
                    onChange={this.onGoalsChange}
                    placeholder="Enter client goals..."
                />

                <PrimaryButton text="Speichern" onClick={this.onSave} />
            </Stack>
        );
    }
}

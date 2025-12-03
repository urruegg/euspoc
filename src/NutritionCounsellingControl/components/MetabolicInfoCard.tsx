import * as React from 'react'
import { 
  Card, 
  Text, 
  Badge,
  Input,
  Spinner,
  MessageBar,
  MessageBarBody,
  MessageBarTitle,
} from '@fluentui/react-components'
import { MetabolicData, ActivityLevel, Gender, ActivityLevelLabels, GenderLabels } from '../types/MetabolicData'
import './MetabolicInfoCard.css'

interface MetabolicInfoCardProps {
  data: MetabolicData | null
  isLoading?: boolean
  error?: string | null
  onActivityChange?: (activityLevel: ActivityLevel) => void
  onWeightChange?: (weight: number) => void
  onGenderChange?: (gender: Gender) => void
}

export const MetabolicInfoCard: React.FC<MetabolicInfoCardProps> = ({
  data,
  isLoading = false,
  error = null,
  onActivityChange,
  onWeightChange,
  onGenderChange,
}) => {
  const [weightValue, setWeightValue] = React.useState('')
  const [isEditingWeight, setIsEditingWeight] = React.useState(false)
  
  // Update local weight value when data changes
  React.useEffect(() => {
    if (data?.weight) {
      setWeightValue(data.weight.toString())
    }
  }, [data?.weight])
  
  const handleWeightBlur = () => {
    setIsEditingWeight(false)
    const numValue = parseFloat(weightValue)
    if (!isNaN(numValue) && numValue > 0 && onWeightChange) {
      onWeightChange(Math.round(numValue))
    } else if (data?.weight) {
      setWeightValue(data.weight.toString())
    }
  }
  
  const handleWeightKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      handleWeightBlur()
    } else if (e.key === 'Escape') {
      if (data?.weight) {
        setWeightValue(data.weight.toString())
      }
      setIsEditingWeight(false)
    }
  }
  
  // Loading state
  if (isLoading) {
    return (
      <Card className="metabolic-card">
        <div className="loading-container">
          <Spinner size="medium" label="Loading metabolic data..." />
        </div>
      </Card>
    )
  }
  
  // Error state
  if (error) {
    return (
      <Card className="metabolic-card">
        <MessageBar intent="error">
          <MessageBarBody>
            <MessageBarTitle>Failed to Load Data</MessageBarTitle>
            {error}
          </MessageBarBody>
        </MessageBar>
      </Card>
    )
  }
  
  // No data state
  if (!data) {
    return (
      <Card className="metabolic-card">
        <MessageBar intent="info">
          <MessageBarBody>
            <MessageBarTitle>No Data Available</MessageBarTitle>
            Metabolic information is not available for this counselling session.
          </MessageBarBody>
        </MessageBar>
      </Card>
    )
  }
  
  // Incomplete data warning
  const isIncomplete = !data.bmr || !data.tdee || !data.targetCalories
  
  return (
    <Card className="metabolic-card">
      <Text className="metabolic-title">Metabolic Information</Text>
      
      {isIncomplete && (
        <MessageBar intent="warning">
          <MessageBarBody>
            <MessageBarTitle>Incomplete Data</MessageBarTitle>
            Some metabolic values are missing. Please update member profile.
          </MessageBarBody>
        </MessageBar>
      )}
      
      <div className="demographics-row">
        <div className="demographic-item">
          <Text className="demographic-label">Height</Text>
          <Text className="demographic-value">
            {data.height ?? '—'} cm
          </Text>
        </div>

        <div className="demographic-item">
          <Text className="demographic-label">Weight</Text>
          {isEditingWeight ? (
            <Input
              type="number"
              value={weightValue}
              onChange={(e, data) => setWeightValue(data.value)}
              onBlur={handleWeightBlur}
              onKeyDown={handleWeightKeyDown}
              contentAfter={<Text size={200}>kg</Text>}
              size="small"
              autoFocus
              style={{ width: '80px' }}
            />
          ) : (
            <Text 
              className="demographic-value"
              style={{ cursor: onWeightChange ? 'pointer' : 'default' }}
              onClick={() => onWeightChange && setIsEditingWeight(true)}
            >
              {data.weight ?? '—'} kg
            </Text>
          )}
        </div>
        
        <div className="demographic-item">
          <Text className="demographic-label">Age</Text>
          <Text className="demographic-value">
            {data.age ?? '—'} yrs
          </Text>
        </div>

        <div className="demographic-item">
          <Text className="demographic-label">Gender</Text>
          <div className="activity-badges">
            <Badge
              appearance="filled"
              color={data.gender === Gender.Male ? 'brand' : 'subtle'}
              size="medium"
              style={{ cursor: onGenderChange ? 'pointer' : 'default' }}
              onClick={() => onGenderChange?.(Gender.Male)}
            >
              Male
            </Badge>
            <Badge
              appearance="filled"
              color={data.gender === Gender.Female ? 'brand' : 'subtle'}
              size="medium"
              style={{ cursor: onGenderChange ? 'pointer' : 'default' }}
              onClick={() => onGenderChange?.(Gender.Female)}
            >
              Female
            </Badge>
          </div>
        </div>
      </div>

      <div className="demographics-row">
        <div className="activity-section">
          <Text className="demographic-label">Activity</Text>
          <div className="activity-badges">
            {Object.entries(ActivityLevelLabels).map(([level, label]) => {
              const activityLevel = Number(level) as ActivityLevel;
              const isSelected = activityLevel === data.activityLevel;
              return (
                <Badge
                  key={level}
                  appearance="filled"
                  color={isSelected ? 'brand' : 'subtle'}
                  size="large"
                  style={{ cursor: onActivityChange ? 'pointer' : 'default' }}
                  onClick={() => onActivityChange?.(activityLevel)}
                >
                  {label}
                </Badge>
              );
            })}
          </div>
        </div>
      </div>
      
      <div className="metrics-row">
        <div className="metric-item">
          <Text className="metric-label">BMR (Basal Metabolic Rate)</Text>
          <Text className="metric-value">
            {data.bmr ? `${data.bmr.toLocaleString()} kcal/day` : '—'}
          </Text>
        </div>
        
        <div className="metric-item">
          <Text className="metric-label">TDEE (Total Daily Energy Expenditure)</Text>
          <Text className="metric-value">
            {data.tdee ? `${data.tdee.toLocaleString()} kcal/day` : '—'}
          </Text>
        </div>
        
        <div className="metric-item">
          <Text className="metric-label">Target Calories</Text>
          <Text className="metric-value">
            {data.targetCalories ? `${data.targetCalories.toLocaleString()} kcal/day` : '—'}
          </Text>
        </div>
      </div>
    </Card>
  )
}

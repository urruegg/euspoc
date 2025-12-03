/**
 * Metabolic information for a member
 */
export interface MetabolicData {
  /** Basal Metabolic Rate (kcal/day) */
  bmr: number | null
  
  /** Total Daily Energy Expenditure (kcal/day) */
  tdee: number | null
  
  /** Target daily calories (kcal/day) */
  targetCalories: number | null
  
  /** Activity level (0-4) */
  activityLevel: ActivityLevel
  
  /** Current weight (kg) */
  weight: number | null
  
  /** Height (cm) */
  height: number | null
  
  /** Age (years) */
  age: number | null
  
  /** Gender */
  gender: Gender
}

/**
 * Activity levels (PAL - Physical Activity Level)
 */
export enum ActivityLevel {
  Sedentary = 0,      // PAL 1.2
  LightlyActive = 1,  // PAL 1.375
  ModeratelyActive = 2, // PAL 1.55
  VeryActive = 3,     // PAL 1.725
  ExtraActive = 4     // PAL 1.9
}

/**
 * Gender options
 */
export enum Gender {
  Male = 0,
  Female = 1,
  Other = 2
}

/**
 * Activity level display labels
 */
export const ActivityLevelLabels: Record<ActivityLevel, string> = {
  [ActivityLevel.Sedentary]: 'Sedentary',
  [ActivityLevel.LightlyActive]: 'Lightly Active',
  [ActivityLevel.ModeratelyActive]: 'Moderately Active',
  [ActivityLevel.VeryActive]: 'Very Active',
  [ActivityLevel.ExtraActive]: 'Extra Active',
}

/**
 * Activity level PAL factors
 */
export const ActivityLevelFactors: Record<ActivityLevel, number> = {
  [ActivityLevel.Sedentary]: 1.2,
  [ActivityLevel.LightlyActive]: 1.375,
  [ActivityLevel.ModeratelyActive]: 1.55,
  [ActivityLevel.VeryActive]: 1.725,
  [ActivityLevel.ExtraActive]: 1.9,
}

/**
 * Gender display labels
 */
export const GenderLabels: Record<Gender, string> = {
  [Gender.Male]: 'Male',
  [Gender.Female]: 'Female',
  [Gender.Other]: 'Other',
}

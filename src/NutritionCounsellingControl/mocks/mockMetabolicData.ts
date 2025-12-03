import { MetabolicData, ActivityLevel, Gender } from '../types/MetabolicData'

export const mockMetabolicData: MetabolicData = {
  bmr: 1650,
  tdee: 2310,
  targetCalories: 2100,
  activityLevel: ActivityLevel.ModeratelyActive,
  weight: 78,
  height: 175,
  age: 34,
  gender: Gender.Male,
}

export const mockMetabolicDataIncomplete: MetabolicData = {
  bmr: null,
  tdee: null,
  targetCalories: null,
  activityLevel: ActivityLevel.Sedentary,
  weight: 78,
  height: 175,
  age: 34,
  gender: Gender.Male,
}

export const mockMetabolicDataPartial: MetabolicData = {
  bmr: 1650,
  tdee: null, // Should be calculated
  targetCalories: 2100,
  activityLevel: ActivityLevel.ModeratelyActive,
  weight: 78,
  height: 175,
  age: 34,
  gender: Gender.Male,
}

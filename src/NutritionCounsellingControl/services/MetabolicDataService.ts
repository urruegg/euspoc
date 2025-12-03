import { IInputs } from '../generated/ManifestTypes'
import { MetabolicData, ActivityLevel, Gender, ActivityLevelFactors } from '../types/MetabolicData'

/**
 * Service for fetching and calculating metabolic data
 */
export class MetabolicDataService {
  private context: ComponentFramework.Context<IInputs>
  
  constructor(context: ComponentFramework.Context<IInputs>) {
    this.context = context
  }
  
  /**
   * Fetch metabolic data for a counselling session
   * @param counsellingId - The ur_nutritioncounselling record ID
   * @returns Promise<MetabolicData>
   */
  async fetchMetabolicData(counsellingId: string): Promise<MetabolicData> {
    try {
      // Fetch counselling record with expanded contact
      const counsellingRecord = await this.context.webAPI.retrieveRecord(
        'ur_nutritioncounselling',
        counsellingId,
        '?$select=ur_bmr,ur_tdee,ur_targetcalories,ur_activitylevel,ur_weight' +
        '&$expand=ur_Member($select=ur_height,ur_age,ur_gender)'
      )
      
      const contact = counsellingRecord.ur_Member
      
      // Parse the data
      const data: MetabolicData = {
        bmr: counsellingRecord.ur_bmr ?? null,
        tdee: counsellingRecord.ur_tdee ?? null,
        targetCalories: counsellingRecord.ur_targetcalories ?? null,
        activityLevel: counsellingRecord.ur_activitylevel ?? ActivityLevel.Sedentary,
        weight: counsellingRecord.ur_weight ?? null,
        height: contact?.ur_height ?? null,
        age: contact?.ur_age ?? null,
        gender: contact?.ur_gender ?? Gender.Other,
      }
      
      // Calculate TDEE if missing but BMR exists
      if (data.bmr && !data.tdee) {
        data.tdee = this.calculateTDEE(data.bmr, data.activityLevel)
      }
      
      return data
    } catch (error) {
      console.error('Error fetching metabolic data:', error)
      throw new Error('Failed to fetch metabolic data')
    }
  }
  
  /**
   * Calculate TDEE from BMR and activity level
   * @param bmr - Basal Metabolic Rate
   * @param activityLevel - Activity level enum
   * @returns Calculated TDEE
   */
  private calculateTDEE(bmr: number, activityLevel: ActivityLevel): number {
    const palFactor = ActivityLevelFactors[activityLevel]
    return Math.round(bmr * palFactor)
  }
  
  /**
   * Validate that metabolic data is complete
   * @param data - MetabolicData to validate
   * @returns true if data is complete
   */
  isDataComplete(data: MetabolicData): boolean {
    return data.bmr !== null && data.tdee !== null && data.targetCalories !== null
  }
}

import * as React from 'react'
import { Text, makeStyles, tokens } from '@fluentui/react-components'

const useStyles = makeStyles({
  row: {
    display: 'flex',
    alignItems: 'center',
    gap: tokens.spacingHorizontalM,
    marginBottom: tokens.spacingVerticalM,
  },
  iconContainer: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    width: '40px',
    height: '40px',
    borderRadius: '50%',
    backgroundColor: tokens.colorNeutralBackground3,
  },
  textContainer: {
    display: 'flex',
    flexDirection: 'column',
    flex: 1,
  },
  label: {
    fontSize: tokens.fontSizeBase300,
    color: tokens.colorNeutralForeground3,
    marginBottom: '2px',
  },
  value: {
    fontSize: tokens.fontSizeBase500,
    fontWeight: tokens.fontWeightSemibold,
    color: tokens.colorNeutralForeground1,
  },
})

interface MetricRowProps {
  icon: React.ComponentType<React.SVGProps<SVGSVGElement>>
  iconColor: string
  label: string
  value: string | null
  placeholder?: string
}

export const MetricRow: React.FC<MetricRowProps> = ({
  icon: Icon,
  iconColor,
  label,
  value,
  placeholder = 'Not calculated',
}) => {
  const styles = useStyles()
  
  return (
    <div className={styles.row}>
      <div className={styles.iconContainer}>
        <Icon style={{ color: iconColor }} />
      </div>
      <div className={styles.textContainer}>
        <Text className={styles.label}>{label}</Text>
        <Text className={styles.value}>
          {value ?? <span style={{ fontStyle: 'italic', opacity: 0.6 }}>{placeholder}</span>}
        </Text>
      </div>
    </div>
  )
}

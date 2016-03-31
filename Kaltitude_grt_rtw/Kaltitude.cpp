/*
 * Kaltitude.cpp
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "Kaltitude".
 *
 * Model version              : 1.91
 * Simulink Coder version : 8.8.1 (R2015aSP1) 04-Sep-2015
 * C++ source code generated on : Wed Mar 30 12:44:15 2016
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#include "Kaltitude.h"
#include "Kaltitude_private.h"

/* Model step function */
void KaltitudeModelClass::step()
{
  real_T A[9];
  static const real_T Qn[9] = { 0.001, 0.0, 0.0, 0.0, 0.001, 0.0, 0.0, 0.0,
    0.001 };

  real_T b_x;
  real_T Rn[4];
  real_T h[2];
  real_T S;
  int32_T j;
  int8_T I[9];
  int8_T b_I[9];
  static const int8_T H[6] = { 0, 1, 1, 0, 0, 0 };

  real_T rtb_TmpSignalConversionAtSFunct[2];
  real_T rtb_x_p[3];
  real_T rtb_K[3];
  real_T rtb_P[9];
  int32_T i;
  real_T A_0[9];
  real_T I_0[9];
  int32_T i_0;

  /* MATLAB Function: '<S3>/Predict ' incorporates:
   *  Constant: '<S3>/Constant'
   *  UnitDelay: '<S3>/Unit Delay'
   */
  /* MATLAB Function 'KALTITUDE/KALTITUDE/Predict ': '<S4>:1' */
  /* %EKF  state update       % */
  /*  Author: Matteo Ferronato% */
  /*  Last review: 2016/02/09 % */
  /* %%%%%%%%%%%%%%%%%%%%%%%%%% */
  /* % Description */
  /*  The purpose of this script is to calculate the state update of */
  /*  Extended Kalman Filter  */
  /* % */
  /* '<S4>:1:12' */
  /*  Qn(1,1)=3; */
  /*  Qn(2,2)=0.01; */
  /* % Initialize variables */
  /* '<S4>:1:17' */
  A[0] = 1.0;
  A[3] = Kaltitude_P.Constant_Value * Kaltitude_P.Constant_Value / 2.0;
  A[6] = Kaltitude_P.Constant_Value;
  A[1] = 0.0;
  A[4] = 1.0;
  A[7] = 0.0;
  A[2] = 0.0;
  A[5] = Kaltitude_P.Constant_Value;
  A[8] = 1.0;

  /* '<S4>:1:21' */
  /* % Jacobian initialization */
  /* '<S4>:1:24' */
  for (i = 0; i < 3; i++) {
    rtb_x_p[i] = A[i + 6] * Kaltitude_DW.UnitDelay_DSTATE[2] + (A[i + 3] *
      Kaltitude_DW.UnitDelay_DSTATE[1] + A[i] * Kaltitude_DW.UnitDelay_DSTATE[0]);
  }

  /* MATLAB Function: '<S1>/Acceleration Correction' incorporates:
   *  Inport: '<Root>/phi'
   *  Inport: '<Root>/theta'
   */
  /* MATLAB Function 'KALTITUDE/Acceleration Correction': '<S2>:1' */
  /* '<S2>:1:3' */
  S = sin(Kaltitude_U.phi);
  b_x = sin(Kaltitude_U.theta);

  /* SignalConversion: '<S5>/TmpSignal ConversionAt SFunction Inport2' incorporates:
   *  Gain: '<S1>/Scale factor'
   *  Inport: '<Root>/az'
   *  Inport: '<Root>/proxy'
   *  MATLAB Function: '<S1>/Acceleration Correction'
   *  MATLAB Function: '<S3>/Update'
   */
  rtb_TmpSignalConversionAtSFunct[0] = sqrt(1.0 - (S * S + b_x * b_x)) *
    (Kaltitude_U.az / 10.06);
  rtb_TmpSignalConversionAtSFunct[1] = Kaltitude_P.Scalefactor_Gain *
    Kaltitude_U.proxy;

  /* MATLAB Function: '<S3>/Update' incorporates:
   *  Constant: '<S3>/Constant1'
   */
  /* MATLAB Function 'KALTITUDE/KALTITUDE/Update': '<S5>:1' */
  /* %EKF  state correction       % */
  /*  Author: Matteo Ferronato% */
  /*  Last review: 2016/02/09 % */
  /* %%%%%%%%%%%%%%%%%%%%%%%%%% */
  /* % Description */
  /*  The purpose of this script is to calculate the state update of */
  /*  Extended Kalman Filter  */
  /* % */
  /*  Useful Parameters */
  /* '<S5>:1:14' */
  Rn[0] = 0.7;
  Rn[1] = 0.0;
  Rn[2] = 0.0;

  /* '<S5>:1:15' */
  Rn[3] = 0.01;

  /* '<S5>:1:17' */
  /* '<S5>:1:18' */
  rtb_TmpSignalConversionAtSFunct[0] -= Kaltitude_P.Constant1_Value[1] / fabs
    (Kaltitude_P.Constant1_Value[1]);

  /* % */
  /* '<S5>:1:22' */
  /*  %% */
  /* '<S5>:1:26' */
  for (i = 0; i < 2; i++) {
    h[i] = (real_T)H[i + 2] * rtb_x_p[1] + (real_T)H[i] * rtb_x_p[0];
  }

  /* MATLAB Function: '<S3>/Predict ' incorporates:
   *  UnitDelay: '<S3>/Unit Delay1'
   */
  /* % */
  /* '<S5>:1:29' */
  for (i = 0; i < 3; i++) {
    for (i_0 = 0; i_0 < 3; i_0++) {
      A_0[i + 3 * i_0] = 0.0;
      A_0[i + 3 * i_0] += Kaltitude_DW.UnitDelay1_DSTATE[3 * i_0] * A[i];
      A_0[i + 3 * i_0] += Kaltitude_DW.UnitDelay1_DSTATE[3 * i_0 + 1] * A[i + 3];
      A_0[i + 3 * i_0] += Kaltitude_DW.UnitDelay1_DSTATE[3 * i_0 + 2] * A[i + 6];
    }
  }

  /* MATLAB Function: '<S3>/Update' incorporates:
   *  MATLAB Function: '<S3>/Predict '
   */
  for (i = 0; i < 3; i++) {
    for (i_0 = 0; i_0 < 3; i_0++) {
      rtb_P[i + 3 * i_0] = ((A_0[i + 3] * A[i_0 + 3] + A_0[i] * A[i_0]) + A_0[i
                            + 6] * A[i_0 + 6]) + Qn[3 * i_0 + i];
    }
  }

  /* '<S5>:1:30' */
  /* '<S5>:1:32' */
  for (j = 0; j < 2; j++) {
    /* '<S5>:1:32' */
    /*  Innovation covariance */
    /* '<S5>:1:34' */
    for (i = 0; i < 3; i++) {
      rtb_K[i] = rtb_P[3 * i + 1] * (real_T)H[j + 2] + rtb_P[3 * i] * (real_T)
        H[j];
    }

    S = ((real_T)H[j + 2] * rtb_K[1] + rtb_K[0] * (real_T)H[j]) + Rn[(j << 1) +
      j];

    /*  Kalman gain */
    /* '<S5>:1:37' */
    for (i = 0; i < 3; i++) {
      rtb_K[i] = (rtb_P[i + 3] * (real_T)H[j + 2] + rtb_P[i] * (real_T)H[j]) / S;
    }

    /*  Updated state estimate */
    /* '<S5>:1:40' */
    S = rtb_TmpSignalConversionAtSFunct[j] - h[j];
    rtb_x_p[0] += rtb_K[0] * S;
    rtb_x_p[1] += rtb_K[1] * S;
    rtb_x_p[2] += rtb_K[2] * S;

    /*  Updated estimated covariance */
    /* '<S5>:1:43' */
    for (i = 0; i < 9; i++) {
      I[i] = 0;
      b_I[i] = 0;
    }

    I[0] = 1;
    I[4] = 1;
    I[8] = 1;
    b_I[0] = 1;
    b_I[4] = 1;
    b_I[8] = 1;
    for (i = 0; i < 3; i++) {
      I_0[i] = (real_T)I[i] - rtb_K[i] * (real_T)H[j];
      I_0[i + 3] = (real_T)I[i + 3] - (real_T)H[j + 2] * rtb_K[i];
      I_0[i + 6] = I[i + 6];
    }

    for (i = 0; i < 3; i++) {
      for (i_0 = 0; i_0 < 3; i_0++) {
        A_0[i + 3 * i_0] = 0.0;
        A_0[i + 3 * i_0] += rtb_P[3 * i_0] * I_0[i];
        A_0[i + 3 * i_0] += rtb_P[3 * i_0 + 1] * I_0[i + 3];
        A_0[i + 3 * i_0] += rtb_P[3 * i_0 + 2] * I_0[i + 6];
      }
    }

    for (i = 0; i < 3; i++) {
      A[i] = (real_T)b_I[3 * i] - (real_T)H[(i << 1) + j] * rtb_K[0];
      A[i + 3] = (real_T)b_I[3 * i + 1] - (real_T)H[(i << 1) + j] * rtb_K[1];
      A[i + 6] = (real_T)b_I[3 * i + 2] - (real_T)H[(i << 1) + j] * rtb_K[2];
    }

    S = Rn[(j << 1) + j];
    for (i = 0; i < 3; i++) {
      for (i_0 = 0; i_0 < 3; i_0++) {
        I_0[i + 3 * i_0] = 0.0;
        I_0[i + 3 * i_0] += A[3 * i_0] * A_0[i];
        I_0[i + 3 * i_0] += A[3 * i_0 + 1] * A_0[i + 3];
        I_0[i + 3 * i_0] += A[3 * i_0 + 2] * A_0[i + 6];
      }
    }

    for (i = 0; i < 3; i++) {
      A[i] = rtb_K[i] * S * rtb_K[0];
      A[i + 3] = rtb_K[i] * S * rtb_K[1];
      A[i + 6] = rtb_K[i] * S * rtb_K[2];
    }

    for (i = 0; i < 3; i++) {
      rtb_P[3 * i] = I_0[3 * i] + A[3 * i];
      rtb_P[1 + 3 * i] = I_0[3 * i + 1] + A[3 * i + 1];
      rtb_P[2 + 3 * i] = I_0[3 * i + 2] + A[3 * i + 2];
    }

    /* '<S5>:1:32' */
  }

  /* Outport: '<Root>/state' */
  /* '<S5>:1:46' */
  /* '<S5>:1:47' */
  Kaltitude_Y.state[0] = rtb_x_p[0];
  Kaltitude_Y.state[1] = rtb_x_p[1];
  Kaltitude_Y.state[2] = rtb_x_p[2];

  /* Update for UnitDelay: '<S3>/Unit Delay' */
  Kaltitude_DW.UnitDelay_DSTATE[0] = rtb_x_p[0];
  Kaltitude_DW.UnitDelay_DSTATE[1] = rtb_x_p[1];
  Kaltitude_DW.UnitDelay_DSTATE[2] = rtb_x_p[2];

  /* Update for UnitDelay: '<S3>/Unit Delay1' */
  memcpy(&Kaltitude_DW.UnitDelay1_DSTATE[0], &rtb_P[0], 9U * sizeof(real_T));
}

/* Model initialize function */
void KaltitudeModelClass::initialize()
{
  /* Registration code */

  /* initialize error status */
  rtmSetErrorStatus((&Kaltitude_M), (NULL));

  /* states (dwork) */
  (void) memset((void *)&Kaltitude_DW, 0,
                sizeof(DW_Kaltitude_T));

  /* external inputs */
  (void) memset((void *)&Kaltitude_U, 0,
                sizeof(ExtU_Kaltitude_T));

  /* external outputs */
  (void) memset(&Kaltitude_Y.state[0], 0,
                3U*sizeof(real_T));

  /* InitializeConditions for UnitDelay: '<S3>/Unit Delay' */
  Kaltitude_DW.UnitDelay_DSTATE[0] = Kaltitude_P.UnitDelay_InitialCondition[0];
  Kaltitude_DW.UnitDelay_DSTATE[1] = Kaltitude_P.UnitDelay_InitialCondition[1];
  Kaltitude_DW.UnitDelay_DSTATE[2] = Kaltitude_P.UnitDelay_InitialCondition[2];

  /* InitializeConditions for UnitDelay: '<S3>/Unit Delay1' */
  memcpy(&Kaltitude_DW.UnitDelay1_DSTATE[0],
         &Kaltitude_P.UnitDelay1_InitialCondition[0], 9U * sizeof(real_T));
}

/* Model terminate function */
void KaltitudeModelClass::terminate()
{
  /* (no terminate code required) */
}

/* Constructor */
KaltitudeModelClass::KaltitudeModelClass()
{
  static const P_Kaltitude_T Kaltitude_P_temp = {
    /*  Expression: zeros(3,1)
     * Referenced by: '<S3>/Unit Delay'
     */
    { 0.0, 0.0, 0.0 },
    0.05,                              /* Expression: 0.05
                                        * Referenced by: '<S3>/Constant'
                                        */

    /*  Expression: eye(3)*0.001
     * Referenced by: '<S3>/Unit Delay1'
     */
    { 0.001, 0.0, 0.0, 0.0, 0.001, 0.0, 0.0, 0.0, 0.001 },
    0.001,                             /* Expression: 0.001
                                        * Referenced by: '<S1>/Scale factor'
                                        */

    /*  Expression: [0;10.0675]
     * Referenced by: '<S3>/Constant1'
     */
    { 0.0, 10.0675 }
  };                                   /* Modifiable parameters */

  /* Initialize tunable parameters */
  Kaltitude_P = Kaltitude_P_temp;
}

/* Destructor */
KaltitudeModelClass::~KaltitudeModelClass()
{
  /* Currently there is no destructor body generated.*/
}

/* Real-Time Model get method */
RT_MODEL_Kaltitude_T * KaltitudeModelClass::getRTM()
{
  return (&Kaltitude_M);
}

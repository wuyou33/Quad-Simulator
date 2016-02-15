/*
 * Mixer.cpp
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "Mixer".
 *
 * Model version              : 1.13
 * Simulink Coder version : 8.8.1 (R2015aSP1) 04-Sep-2015
 * C++ source code generated on : Tue Feb 09 16:04:10 2016
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#include "Mixer.h"
#include "Mixer_private.h"

/* Model step function */
void MixerModelClass::step()
{
  real_T tmp[4];
  int32_T i;
  real_T rtb_Th_idx_0;
  real_T rtb_Th_idx_1;
  real_T rtb_Th_idx_2;
  real_T rtb_Th_idx_3;
  real_T tmp_0;

  /* Gain: '<S1>/Gain3' */
  rtb_Th_idx_3 = 1.0 / Mixer_P.x1[0];

  /* Gain: '<S1>/Gain2' incorporates:
   *  Inport: '<Root>/moment_x'
   *  Inport: '<Root>/moment_y'
   *  Inport: '<Root>/moment_z'
   *  Inport: '<Root>/thrust'
   *  Sqrt: '<S1>/Sqrt1'
   *
   * About '<S1>/Sqrt1':
   *  Operator: signedSqrt
   */
  for (i = 0; i < 4; i++) {
    tmp_0 = Mixer_P.Kinv[i + 12] * Mixer_U.moment_z + (Mixer_P.Kinv[i + 8] *
      Mixer_U.moment_y + (Mixer_P.Kinv[i + 4] * Mixer_U.moment_x +
                          Mixer_P.Kinv[i] * Mixer_U.thrust));
    tmp[i] = tmp_0;
  }

  /* Gain: '<S1>/Gain3' incorporates:
   *  Bias: '<S1>/Bias1'
   *  Gain: '<S1>/Gain2'
   *  Sqrt: '<S1>/Sqrt1'
   *
   * About '<S1>/Sqrt1':
   *  Operator: signedSqrt
   */
  if (tmp[0] < 0.0) {
    tmp_0 = -sqrt(fabs(tmp[0]));
  } else {
    tmp_0 = sqrt(tmp[0]);
  }

  rtb_Th_idx_0 = (tmp_0 + -Mixer_P.x1[1]) * rtb_Th_idx_3;
  if (tmp[1] < 0.0) {
    tmp_0 = -sqrt(fabs(tmp[1]));
  } else {
    tmp_0 = sqrt(tmp[1]);
  }

  rtb_Th_idx_1 = (tmp_0 + -Mixer_P.x1[1]) * rtb_Th_idx_3;
  if (tmp[2] < 0.0) {
    tmp_0 = -sqrt(fabs(tmp[2]));
  } else {
    tmp_0 = sqrt(tmp[2]);
  }

  rtb_Th_idx_2 = (tmp_0 + -Mixer_P.x1[1]) * rtb_Th_idx_3;
  if (tmp[3] < 0.0) {
    tmp_0 = -sqrt(fabs(tmp[3]));
  } else {
    tmp_0 = sqrt(tmp[3]);
  }

  rtb_Th_idx_3 *= tmp_0 + -Mixer_P.x1[1];

  /* Saturate: '<S1>/Saturation' */
  if (rtb_Th_idx_0 > Mixer_P.Saturation_UpperSat) {
    /* Outport: '<Root>/th1' */
    Mixer_Y.th1 = Mixer_P.Saturation_UpperSat;
  } else if (rtb_Th_idx_0 < Mixer_P.Saturation_LowerSat) {
    /* Outport: '<Root>/th1' */
    Mixer_Y.th1 = Mixer_P.Saturation_LowerSat;
  } else {
    /* Outport: '<Root>/th1' */
    Mixer_Y.th1 = rtb_Th_idx_0;
  }

  /* End of Saturate: '<S1>/Saturation' */

  /* Saturate: '<S1>/Saturation1' */
  if (rtb_Th_idx_1 > Mixer_P.Saturation1_UpperSat) {
    /* Outport: '<Root>/th2' */
    Mixer_Y.th2 = Mixer_P.Saturation1_UpperSat;
  } else if (rtb_Th_idx_1 < Mixer_P.Saturation1_LowerSat) {
    /* Outport: '<Root>/th2' */
    Mixer_Y.th2 = Mixer_P.Saturation1_LowerSat;
  } else {
    /* Outport: '<Root>/th2' */
    Mixer_Y.th2 = rtb_Th_idx_1;
  }

  /* End of Saturate: '<S1>/Saturation1' */

  /* Saturate: '<S1>/Saturation2' */
  if (rtb_Th_idx_2 > Mixer_P.Saturation2_UpperSat) {
    /* Outport: '<Root>/th3' */
    Mixer_Y.th3 = Mixer_P.Saturation2_UpperSat;
  } else if (rtb_Th_idx_2 < Mixer_P.Saturation2_LowerSat) {
    /* Outport: '<Root>/th3' */
    Mixer_Y.th3 = Mixer_P.Saturation2_LowerSat;
  } else {
    /* Outport: '<Root>/th3' */
    Mixer_Y.th3 = rtb_Th_idx_2;
  }

  /* End of Saturate: '<S1>/Saturation2' */

  /* Saturate: '<S1>/Saturation3' */
  if (rtb_Th_idx_3 > Mixer_P.Saturation3_UpperSat) {
    /* Outport: '<Root>/th4 ' */
    Mixer_Y.th4 = Mixer_P.Saturation3_UpperSat;
  } else if (rtb_Th_idx_3 < Mixer_P.Saturation3_LowerSat) {
    /* Outport: '<Root>/th4 ' */
    Mixer_Y.th4 = Mixer_P.Saturation3_LowerSat;
  } else {
    /* Outport: '<Root>/th4 ' */
    Mixer_Y.th4 = rtb_Th_idx_3;
  }

  /* End of Saturate: '<S1>/Saturation3' */
}

/* Model initialize function */
void MixerModelClass::initialize()
{
  /* Registration code */

  /* initialize error status */
  rtmSetErrorStatus((&Mixer_M), (NULL));

  /* external inputs */
  (void) memset((void *)&Mixer_U, 0,
                sizeof(ExtU_Mixer_T));

  /* external outputs */
  (void) memset((void *)&Mixer_Y, 0,
                sizeof(ExtY_Mixer_T));
}

/* Model terminate function */
void MixerModelClass::terminate()
{
  /* (no terminate code required) */
}

/* Constructor */
MixerModelClass::MixerModelClass()
{
  static const P_Mixer_T Mixer_P_temp = {
    /*  Variable: Kinv
     * Referenced by: '<S1>/Gain2'
     */
    { 10154.676913023777, 10154.676913023777, 10154.676913023777,
      10154.676913023777, 52221.388406964288, -52221.388406964288,
      -52221.388406964288, 52221.388406964288, 52221.388406964288,
      52221.388406964288, -52221.388406964288, -52221.388406964288,
      -865274.28680549655, 865274.28680549655, -865274.28680549655,
      865274.28680549655 },

    /*  Variable: x1
     * Referenced by:
     *   '<S1>/Bias1'
     *   '<S1>/Gain3'
     */
    { 6.0312, 80.4859 },
    100.0,                             /* Expression: 100
                                        * Referenced by: '<S1>/Saturation'
                                        */
    0.0,                               /* Expression: 0
                                        * Referenced by: '<S1>/Saturation'
                                        */
    100.0,                             /* Expression: 100
                                        * Referenced by: '<S1>/Saturation1'
                                        */
    0.0,                               /* Expression: 0
                                        * Referenced by: '<S1>/Saturation1'
                                        */
    100.0,                             /* Expression: 100
                                        * Referenced by: '<S1>/Saturation2'
                                        */
    0.0,                               /* Expression: 0
                                        * Referenced by: '<S1>/Saturation2'
                                        */
    100.0,                             /* Expression: 100
                                        * Referenced by: '<S1>/Saturation3'
                                        */
    0.0                                /* Expression: 0
                                        * Referenced by: '<S1>/Saturation3'
                                        */
  };                                   /* Modifiable parameters */

  /* Initialize tunable parameters */
  Mixer_P = Mixer_P_temp;
}

/* Destructor */
MixerModelClass::~MixerModelClass()
{
  /* Currently there is no destructor body generated.*/
}

/* Real-Time Model get method */
RT_MODEL_Mixer_T * MixerModelClass::getRTM()
{
  return (&Mixer_M);
}

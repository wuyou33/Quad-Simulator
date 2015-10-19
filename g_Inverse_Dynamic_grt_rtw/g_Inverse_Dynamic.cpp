/*
 * g_Inverse_Dynamic.cpp
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "g_Inverse_Dynamic".
 *
 * Model version              : 1.9
 * Simulink Coder version : 8.8 (R2015a) 09-Feb-2015
 * C++ source code generated on : Thu Oct 15 14:21:28 2015
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#include "g_Inverse_Dynamic.h"
#include "g_Inverse_Dynamic_private.h"

/* Model step function */
void g_Inverse_DynamicModelClass::step()
{
  real_T tmp[4];
  int32_T i;
  real_T rtb_Th_idx_0;
  real_T rtb_Th_idx_1;
  real_T rtb_Th_idx_2;
  real_T rtb_Th_idx_3;
  real_T tmp_0;

  /* Gain: '<S1>/Gain3' */
  rtb_Th_idx_3 = 1.0 / g_Inverse_Dynamic_P.x1[0];

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
    tmp_0 = g_Inverse_Dynamic_P.Kinv[i + 12] * g_Inverse_Dynamic_U.moment_z +
      (g_Inverse_Dynamic_P.Kinv[i + 8] * g_Inverse_Dynamic_U.moment_y +
       (g_Inverse_Dynamic_P.Kinv[i + 4] * g_Inverse_Dynamic_U.moment_x +
        g_Inverse_Dynamic_P.Kinv[i] * g_Inverse_Dynamic_U.thrust));
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

  rtb_Th_idx_0 = (tmp_0 + -g_Inverse_Dynamic_P.x1[1]) * rtb_Th_idx_3;
  if (tmp[1] < 0.0) {
    tmp_0 = -sqrt(fabs(tmp[1]));
  } else {
    tmp_0 = sqrt(tmp[1]);
  }

  rtb_Th_idx_1 = (tmp_0 + -g_Inverse_Dynamic_P.x1[1]) * rtb_Th_idx_3;
  if (tmp[2] < 0.0) {
    tmp_0 = -sqrt(fabs(tmp[2]));
  } else {
    tmp_0 = sqrt(tmp[2]);
  }

  rtb_Th_idx_2 = (tmp_0 + -g_Inverse_Dynamic_P.x1[1]) * rtb_Th_idx_3;
  if (tmp[3] < 0.0) {
    tmp_0 = -sqrt(fabs(tmp[3]));
  } else {
    tmp_0 = sqrt(tmp[3]);
  }

  rtb_Th_idx_3 *= tmp_0 + -g_Inverse_Dynamic_P.x1[1];

  /* Saturate: '<S1>/Saturation' */
  if (rtb_Th_idx_0 > g_Inverse_Dynamic_P.Saturation_UpperSat) {
    /* Outport: '<Root>/th1' */
    g_Inverse_Dynamic_Y.th1 = g_Inverse_Dynamic_P.Saturation_UpperSat;
  } else if (rtb_Th_idx_0 < g_Inverse_Dynamic_P.Saturation_LowerSat) {
    /* Outport: '<Root>/th1' */
    g_Inverse_Dynamic_Y.th1 = g_Inverse_Dynamic_P.Saturation_LowerSat;
  } else {
    /* Outport: '<Root>/th1' */
    g_Inverse_Dynamic_Y.th1 = rtb_Th_idx_0;
  }

  /* End of Saturate: '<S1>/Saturation' */

  /* Saturate: '<S1>/Saturation1' */
  if (rtb_Th_idx_1 > g_Inverse_Dynamic_P.Saturation1_UpperSat) {
    /* Outport: '<Root>/th2' */
    g_Inverse_Dynamic_Y.th2 = g_Inverse_Dynamic_P.Saturation1_UpperSat;
  } else if (rtb_Th_idx_1 < g_Inverse_Dynamic_P.Saturation1_LowerSat) {
    /* Outport: '<Root>/th2' */
    g_Inverse_Dynamic_Y.th2 = g_Inverse_Dynamic_P.Saturation1_LowerSat;
  } else {
    /* Outport: '<Root>/th2' */
    g_Inverse_Dynamic_Y.th2 = rtb_Th_idx_1;
  }

  /* End of Saturate: '<S1>/Saturation1' */

  /* Saturate: '<S1>/Saturation2' */
  if (rtb_Th_idx_2 > g_Inverse_Dynamic_P.Saturation2_UpperSat) {
    /* Outport: '<Root>/th3' */
    g_Inverse_Dynamic_Y.th3 = g_Inverse_Dynamic_P.Saturation2_UpperSat;
  } else if (rtb_Th_idx_2 < g_Inverse_Dynamic_P.Saturation2_LowerSat) {
    /* Outport: '<Root>/th3' */
    g_Inverse_Dynamic_Y.th3 = g_Inverse_Dynamic_P.Saturation2_LowerSat;
  } else {
    /* Outport: '<Root>/th3' */
    g_Inverse_Dynamic_Y.th3 = rtb_Th_idx_2;
  }

  /* End of Saturate: '<S1>/Saturation2' */

  /* Saturate: '<S1>/Saturation3' */
  if (rtb_Th_idx_3 > g_Inverse_Dynamic_P.Saturation3_UpperSat) {
    /* Outport: '<Root>/th4 ' */
    g_Inverse_Dynamic_Y.th4 = g_Inverse_Dynamic_P.Saturation3_UpperSat;
  } else if (rtb_Th_idx_3 < g_Inverse_Dynamic_P.Saturation3_LowerSat) {
    /* Outport: '<Root>/th4 ' */
    g_Inverse_Dynamic_Y.th4 = g_Inverse_Dynamic_P.Saturation3_LowerSat;
  } else {
    /* Outport: '<Root>/th4 ' */
    g_Inverse_Dynamic_Y.th4 = rtb_Th_idx_3;
  }

  /* End of Saturate: '<S1>/Saturation3' */
}

/* Model initialize function */
void g_Inverse_DynamicModelClass::initialize()
{
  /* Registration code */

  /* initialize error status */
  rtmSetErrorStatus((&g_Inverse_Dynamic_M), (NULL));

  /* external inputs */
  (void) memset((void *)&g_Inverse_Dynamic_U, 0,
                sizeof(ExtU_g_Inverse_Dynamic_T));

  /* external outputs */
  (void) memset((void *)&g_Inverse_Dynamic_Y, 0,
                sizeof(ExtY_g_Inverse_Dynamic_T));
}

/* Model terminate function */
void g_Inverse_DynamicModelClass::terminate()
{
  /* (no terminate code required) */
}

/* Constructor */
g_Inverse_DynamicModelClass::g_Inverse_DynamicModelClass()
{
  static const P_g_Inverse_Dynamic_T g_Inverse_Dynamic_P_temp = {
    /*  Variable: Kinv
     * Referenced by: '<S1>/Gain2'
     */
    { 10154.676913023777, 10154.676913023781, 10154.676913023774,
      10154.676913023779, 52221.388406964274, -52221.388406964274,
      -52221.3884069643, 52221.388406964295, 52221.38840696431,
      52221.388406964274, -52221.388406964274, -52221.388406964295,
      865274.28680549667, -865274.28680549655, 865274.28680549655,
      -865274.28680549655 },

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
  g_Inverse_Dynamic_P = g_Inverse_Dynamic_P_temp;
}

/* Destructor */
g_Inverse_DynamicModelClass::~g_Inverse_DynamicModelClass()
{
  /* Currently there is no destructor body generated.*/
}

/* Real-Time Model get method */
RT_MODEL_g_Inverse_Dynamic_T * g_Inverse_DynamicModelClass::getRTM()
{
  return (&g_Inverse_Dynamic_M);
}

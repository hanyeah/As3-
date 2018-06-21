package com.hanyeah.math{
	public class HMath{
		/**
		 * 双曲余弦
		 * @param	x
		 * @return
		 */
		public static function cosh(x:Number):Number {
			return (Math.exp(x) + Math.exp(-x)) * 0.5;
		}
		
		/**
		 * 双曲正弦
		 * @param	x
		 * @return
		 */
		public static function sinh(x:Number):Number {
			return (Math.exp(x) - Math.exp(-x)) * 0.5;
		}
		
		/**
		 * 当x很小时，用泰勒级数求cox(x)-1
		 * @param	x
		 * @return
		 */
		public static function cosm1(x:Number):Number{
			var limit:Number = Math.PI/4;
			if (x < -limit || x > limit) {
				return (Math.cos(x) - 1.0);
			}

		    var xx:Number = x * x;
		    return xx *
		      (-0.5 + xx *
		        (1/24 + xx *
		          (-1/720 + xx *
		            (1/40320 + xx *
		              (-1/3628800 + xx *
		                (1/4790014600 + xx *
		                  (-1/87178291200 + xx *
		                    (1/20922789888000)
		                  )
		                )
		              )
		            )
		          )
		        )
		      );
		}
		
		/**
		 * sqrt(x*x+y*y)
		 * @param	x
		 * @param	y
		 * @return
		 */
		public static function hypot(x:Number,y:Number):Number{
			var a:Number = Math.abs(x);
		    var b:Number = Math.abs(y);

		    if (a < 3000 && b < 3000) {
		      return Math.sqrt(a * a + b * b);
		    }

		    if (a < b) {
		      a = b;
		      b = x / y;
		    } else {
		      b = y / x;
		    }
		    return a * Math.sqrt(1 + b * b); 
		}
		
		public static function logHypot(a:Number,b:Number):Number{
			var _a:Number = Math.abs(a);
		    var _b:Number = Math.abs(b);

		    if (a === 0) {
		      return Math.log(_b);
		    }

		    if (b === 0) {
		      return Math.log(_a);
		    }

		    if (_a < 3000 && _b < 3000) {
		      return Math.log(a * a + b * b) * 0.5;
		    }

		    /* I got 4 ideas to compute this property without overflow:
		     *
		     * Testing 1000000 times with random samples for a,b ∈ [1, 1000000000] against a big decimal library to get an error estimate
		     *
		     * 1. Only eliminate the square root: (OVERALL ERROR: 3.9122483030951116e-11)

		     Math.log(a * a + b * b) / 2

		     *
		     *
		     * 2. Try to use the non-overflowing pythagoras: (OVERALL ERROR: 8.889760039210159e-10)

		     var fn = function(a, b) {
		     a = Math.abs(a);
		     b = Math.abs(b);
		     var t = Math.min(a, b);
		     a = Math.max(a, b);
		     t = t / a;

		     return Math.log(a) + Math.log(1 + t * t) / 2;
		     };

		     * 3. Abuse the identity cos(atan(y/x) = x / sqrt(x^2+y^2): (OVERALL ERROR: 3.4780178737037204e-10)

		     Math.log(a / Math.cos(Math.atan2(b, a)))

		     * 4. Use 3. and apply log rules: (OVERALL ERROR: 1.2014087502620896e-9)

		     Math.log(a) - Math.log(Math.cos(Math.atan2(b, a)))

		     */

		    return Math.log(a / Math.cos(Math.atan2(b, a)));
		}
		
		public static function expm1(a:Number):Number{
			return Math.exp(a) - 1;
		}
		
	}
}
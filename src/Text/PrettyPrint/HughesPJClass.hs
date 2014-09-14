-- | Pretty printing class, simlar to 'Show' but nicer looking.
-- Note that the precedence level is a 'Rational' so there is an unlimited number of levels.
-- Based on "Text.PrettyPrint.HughesPJ", which is re-exported.
module Text.PrettyPrint.HughesPJClass(
    Pretty(..),
    PrettyLevel(..), prettyNormal,
    prettyShow, prettyParen,
    module Text.PrettyPrint.HughesPJ
    ) where
import Text.PrettyPrint.HughesPJ
import Data.Ratio

-- | Level of detail in the pretty printed output.
-- Level 0 is the least detail.
newtype PrettyLevel = PrettyLevel Int
    deriving (Eq, Ord, Show)

prettyNormal :: PrettyLevel
prettyNormal = PrettyLevel 0

-- | Pretty printing class.  The precedence level is used in a similar way as in the 'Show' class.
-- Minimal complete definition is either 'pPrintPrec' or 'pPrint'.
class Pretty a where
    pPrintPrec :: PrettyLevel -> Rational -> a -> Doc
    pPrint :: a -> Doc
    pPrintList :: PrettyLevel -> [a] -> Doc

    pPrintPrec _ _ = pPrint
    pPrint = pPrintPrec prettyNormal 0
    pPrintList l = brackets . fsep . punctuate comma . map (pPrintPrec l 0)

-- | Pretty print a value with the 'prettyNormal' level.
prettyShow :: (Pretty a) => a -> String
prettyShow = render . pPrint

pPrint0 :: (Pretty a) => PrettyLevel -> a -> Doc
pPrint0 l = pPrintPrec l 0

appPrec :: Rational
appPrec = 10

-- | Parenthesize an value if the boolean is true.
prettyParen :: Bool -> Doc -> Doc
prettyParen False = id
prettyParen True = parens

-- XXX Doesn't treat signs like Show.
instance Pretty Int where pPrint = int
instance Pretty Integer where pPrint = integer
instance Pretty Float where pPrint = float
instance Pretty Double where pPrint = double
instance Pretty () where pPrint _ = text "()"
instance Pretty Bool where pPrint = text . show
instance Pretty Ordering where pPrint = text . show
instance Pretty Char where
    pPrint = char
    pPrintList _ = text
instance (Pretty a) => Pretty (Maybe a) where
    pPrintPrec l p Nothing = text "Nothing"
    pPrintPrec l p (Just x) = prettyParen (p > appPrec) $ text "Just" <+> pPrintPrec l (appPrec+1) x
instance (Pretty a, Pretty b) => Pretty (Either a b) where
    pPrintPrec l p (Left x) = prettyParen (p > appPrec) $ text "Left" <+> pPrintPrec l (appPrec+1) x
    pPrintPrec l p (Right x) = prettyParen (p > appPrec) $ text "Right" <+> pPrintPrec l (appPrec+1) x

instance (Pretty a) => Pretty [a] where
    pPrintPrec l _ xs = pPrintList l xs

instance (Pretty a, Pretty b) => Pretty (a, b) where
    pPrintPrec l _ (a, b) =
        parens $ fsep $ punctuate comma [pPrint0 l a, pPrint0 l b]

instance (Pretty a, Pretty b, Pretty c) => Pretty (a, b, c) where
    pPrintPrec l _ (a, b, c) =
        parens $ fsep $ punctuate comma [pPrint0 l a, pPrint0 l b, pPrint0 l c]

instance (Pretty a, Pretty b, Pretty c, Pretty d) => Pretty (a, b, c, d) where
    pPrintPrec l _ (a, b, c, d) =
        parens $ fsep $ punctuate comma [pPrint0 l a, pPrint0 l b, pPrint0 l c, pPrint0 l d]

instance (Pretty a, Pretty b, Pretty c, Pretty d, Pretty e) => Pretty (a, b, c, d, e) where
    pPrintPrec l _ (a, b, c, d, e) =
        parens $ fsep $ punctuate comma [pPrint0 l a, pPrint0 l b, pPrint0 l c, pPrint0 l d, pPrint0 l e]

instance (Pretty a, Pretty b, Pretty c, Pretty d, Pretty e, Pretty f) => Pretty (a, b, c, d, e, f) where
    pPrintPrec l _ (a, b, c, d, e, f) =
        parens $ fsep $ punctuate comma [pPrint0 l a, pPrint0 l b, pPrint0 l c, pPrint0 l d, pPrint0 l e, pPrint0 l f]

instance (Pretty a, Pretty b, Pretty c, Pretty d, Pretty e, Pretty f, Pretty g) =>
         Pretty (a, b, c, d, e, f, g) where
    pPrintPrec l _ (a, b, c, d, e, f, g) =
        parens $ fsep $ punctuate comma [pPrint0 l a, pPrint0 l b, pPrint0 l c, pPrint0 l d, pPrint0 l e, pPrint0 l f, pPrint0 l g]

instance (Pretty a, Pretty b, Pretty c, Pretty d, Pretty e, Pretty f, Pretty g, Pretty h) =>
         Pretty (a, b, c, d, e, f, g, h) where
    pPrintPrec l _ (a, b, c, d, e, f, g, h) =
        parens $ fsep $ punctuate comma [pPrint0 l a, pPrint0 l b, pPrint0 l c, pPrint0 l d, pPrint0 l e, pPrint0 l f, pPrint0 l g, pPrint0 l h]


from typing import (
    List,
    Tuple
)
from vips_utils import (
    to_set
)

@to_set
def return_value() -> List[int]:
    return [1, 1, 2]

x = return_value()
reveal_type(x)
